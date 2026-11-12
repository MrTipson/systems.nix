{
  config,
  pkgs,
  lib,
  ...
}:
{
  # liquidsoap uses a DSL to create streams
  services.liquidsoap.streams.main = pkgs.writeText "liquidsoap-main" ''
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

    output.harbor(%opus, port = 8000, mount = "main.opus", fallible = false, headers = [("Access-Control-Allow-Origin", "*")], album_rotation_with_covers)

    def handler(request, response) =
      #log(
      #  "Got a request on path #{request.path}, protocol version: #{
      #    request.http_version
      #  }, method: #{request.method}, headers: #{request.headers}, query: #{
      #    request.query
      #  }, body: #{request.body()}"
      #)
      response.headers([
        ("Access-Control-Allow-Origin", "*"),
        ("Access-Control-Allow-Headers", "range, if-range, icy-metadata"),
        ("Access-Control-Allow-Methods", "GET, OPTIONS"),
        ("Access-Control-Expose-Headers", "content-range, icy-br, icy-description, icy-genre, icy-name, icy-pub, icy-url, icy-metadata")
      ])
    end

    harbor.http.register(port=8000, method="OPTIONS", "/main.opus", handler)
  '';

  networking.firewall.allowedTCPPorts = [ 8000 ];
}
