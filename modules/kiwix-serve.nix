{ config, pkgs, lib, ... }: let
  zimFiles = builtins.map builtins.fetchurl [
    { url = "https://download.kiwix.org/zim/other/archlinux_en_all_maxi_2025-04.zim";
      sha256 = "sha256:1093zf7nf4g983kcg5ks87s59fba2azr02ki3bjgbs5x8007zya3"; }
    { url = "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2024-01.zim";
      sha256 = "sha256:1157gbw7jkx3yxhr4ga062gi0w8gj99q8w91gjyij5njfiblbd0s"; }
    { url = "https://download.kiwix.org/zim/devdocs/devdocs_en_nix_2025-04.zim";
      sha256 = "sha256:0inrlxxyx8czpyhfznbm57xksblw1a3aj3gsx7yl103zr8hyxqhw"; }
  ];
  port = builtins.toString 3002;
in {
  systemd.services.kiwix = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Self hosted wikis";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kiwix-tools}/bin/kiwix-serve --port=${port} ${builtins.concatStringsSep " " zimFiles}'';
    };
  };

  systemd.services.mDNS-kiwix = {
    enable = true;
    after = [ "kiwix.service" ];
    wantedBy = [ "default.target" ];
    description = "mDNS kiwix advertisement";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.avahi}/bin/avahi-publish -a -R wiki.local 192.168.64.228'';
    };
  };

  users.users.wikix = {
    isNormalUser = true;
    description = "Wikix server users";
    group = "wikix";
  };
  users.groups.wikix = { };
  
  services.caddy.virtualHosts."wiki.local".extraConfig = ''
    reverse_proxy :${port}
  '';
}
