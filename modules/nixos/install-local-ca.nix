{ pkgs, lib, config, ... }:
{
  security.pki.certificateFiles = [ 
    (builtins.fetchurl {
      url = "http://ca.local/";
      sha256 = "";
    })
  ];
}
