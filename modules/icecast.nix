{
  config,
  pkgs,
  lib,
  ...
}:
let
  liquidsoap = pkgs.liquidsoap.overrideAttrs (old: {
    patches = old.patches or [ ] ++ [
      ./chungus.patch
    ];
  });
  icecast = pkgs.icecast.overrideAttrs (old: {
    patches = old.patches or [ ] ++ [
      (pkgs.fetchpatch2 {
        name = "check-null";
        url = "https://gitlab.xiph.org/-/project/2/uploads/d2f8d747ee35cd1a3cd7b3f647d28c53/check-null.patch";
        hash = "sha256-e7ORO9ajbrSBkqvstCiNiLtTrQqvvDHq4AIYDDDHllY=";
      })
    ];
  });
  mkMount = mount: user: password: ''
    <mount>
      <mount-name>${mount}</mount-name>
      <username>${user}</username>
      <password>${password}</password>
      <public>0</public>
      <hidden>1</hidden>
      <burst-size>65536</burst-size>
      <type>audio/ogg</type>
      <subtype>opus</subtype>
    </mount>
  '';
  simpleSecret = sopsFile: key: {
    inherit sopsFile key;
    format = "json";
  };
  ph = config.sops.placeholder;
in
{
  sops.secrets = {
    icecast-user = simpleSecret ../secrets/icecast.json "user";
    icecast-password = simpleSecret ../secrets/icecast.json "password";
    liquidsoap-user = simpleSecret ../secrets/liquidsoap.json "user";
    liquidsoap-pass-main = simpleSecret ../secrets/liquidsoap.json "password-main";
  };
  sops.templates."icecast.xml".content = ''
    <?xml version="1.0"?>
    <icecast>
      <http-headers>
          <header type="cors" name="Access-Control-Allow-Origin" value="*" />
          <header type="cors" name="Access-Control-Allow-Headers" value="range, if-range, icy-metadata"/>
          <header type="cors" name="Access-Control-Allow-Methods" value="GET, OPTIONS"/>
          <header type="cors" name="Access-Control-Expose-Headers" value="content-range, icy-br, icy-description, icy-genre, icy-name, icy-pub, icy-url, icy-metadata" />
      </http-headers>
      <hostname>icecast.tipson.xyz</hostname>

      <authentication>
        <admin-user>${ph.icecast-user}</admin-user>
        <admin-password>${ph.icecast-password}</admin-password>
      </authentication>

      <paths>
        <logdir>/var/log/icecast</logdir>
        <adminroot>${icecast}/share/icecast/admin</adminroot>
        <webroot>${icecast}/share/icecast/web</webroot>
        <alias source="/" dest="/status.xsl"/>
      </paths>

      <listen-socket>
        <port>8000</port>
        <bind-address>::</bind-address>
      </listen-socket>

      <security>
        <chroot>0</chroot>
      </security>

      ${mkMount "/main.opus" ph.liquidsoap-user ph.liquidsoap-pass-main}
    </icecast>
  '';
  # icecast handles sending streams to clients
  # the options are a bit silly because icecast is a bit silly so just use it to set up service info
  services.icecast = {
    enable = true;
    hostname = "-";
    admin = {
      user = "-";
      password = "-";
    };
  };
  networking.firewall.allowedTCPPorts = [ 8000 ];
  systemd.services.icecast.serviceConfig.LoadCredential = "config:${
    config.sops.templates."icecast.xml".path
  }";
  systemd.services.icecast.serviceConfig.ExecStart =
    lib.mkForce "${lib.getExe icecast} -c \${CREDENTIALS_DIRECTORY}/config";

  # use environment file for authentication and inject it into each service definition
  sops.secrets.liquidsoap = {
    sopsFile = ../secrets/liquidsoap.json;
    format = "json";
    key = ""; # whole file
  };
  # this imports trick is so we can use systemd.services.* normally
  imports = [
    {
      systemd.services = builtins.mapAttrs (_: stream: {
        serviceConfig.LoadCredential = "creds:${config.sops.secrets.liquidsoap.path}";
        serviceConfig.ExecStart = lib.mkForce "${lib.getExe liquidsoap} ${stream}";
      }) config.services.liquidsoap.streams;
    }
  ];
  # liquidsoap uses a DSL to create streams
  services.liquidsoap.streams.icecast-main = pkgs.writeText "liquidsoap-main" ''
    let json.parse (creds: {
      user: string,
      "password-main" as password: string
    }) = file.contents(path.concat(environment.get("CREDENTIALS_DIRECTORY"), "creds"))
    mount = "main.opus"
    settings.request.metadata_decoders.recode.exclude := [ "acoustid_fingerprint" ]
    settings.charset.max_string_length := 100000

    albums = ref([])
    tracks = ref([])
    coverimg = ref("")

    command_fetch_albums = "${lib.getExe pkgs.fd} cover /storage/music -x dirname | shuf | head -c -1"
    command_encode_cover = fun (path) -> "${lib.getExe pkgs.imagemagick} \"#{path}\" -resize 256x256 WEBP:- | base64 -w0"

    def get_next()
        if albums() == [] then
            albums.set(process.read.lines(command_fetch_albums))
        end
        if tracks() == [] then
            let [hd, ...tl] = albums()
            let [...songs, cover] = file.ls(absolute=true, sorted=true, hd)
            tracks.set(songs)
            albums.set(tl)
            coverimg.set(process.read(command_encode_cover(cover)))
        end
        let [hd, ...tl] = tracks()
        tracks.set(tl)
        request.create(hd)
    end

    album_rotation = mksafe(request.dynamic(id="album_rotation", retry_delay=5., get_next))
    album_rotation_with_covers = metadata.map(fun (m) -> [("comment", coverimg())], album_rotation)

    output.icecast(%opus,
        host = "localhost",
        port = 8000,
        user = creds.user,
        password = creds.password,
        mount = mount,
        fallible = false,
        album_rotation_with_covers)
  '';
}
