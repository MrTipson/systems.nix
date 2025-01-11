{ config, pkgs, lib, ... }:

{
  imports = with import ../../modules/home-manager; [
    terminal.fish
    terminal.superfile

    ssh.github

    graphical.discord
    graphical.hyprland
    graphical.kitty
    graphical.pipewire
    graphical.soteria
    graphical.swaync
    graphical.tofi
    graphical.vscode
    graphical.waybar

    binds-hyprland
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tipson";
  home.homeDirectory = "/home/tipson";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    wl-clipboard
    hyprshot # screenshot tool
    zenith-nvidia # hardware monitor
  ];

  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "MrTipson";
    userEmail = "gunfight7.gf@gmail.com";
  };
  programs.firefox.enable = true;

  home.file = {
    ".sops.yaml".text = ''
      keys:
        - &mrtipson age1lp6w8qkkzcuvgz6md0wjc98e60nky3exme7uaz232mza7vqts95q824yeg
      creation_rules:
        - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
          key_groups:
          - age:
            - *mrtipson
    '';
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      input {
        kb_layout = si
      }
    '';
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
