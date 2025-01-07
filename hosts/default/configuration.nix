{ pkgs, inputs, ... }:
{
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Ljubljana";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "slovene";
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true; # Allows vscode remote ssh to work

  # services.resolved.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    gnumake
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];
}
