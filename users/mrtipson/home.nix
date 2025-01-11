{ config, pkgs, lib, ... }:

let tofi-font-pkg = pkgs.nerd-fonts.fira-code;
    tofi-font = "${tofi-font-pkg}/share/fonts/truetype/NerdFonts/FiraCodeNerdFontMono-Retina.ttf";
in
{
  imports = with import ../../modules/home-manager; [
    fish
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
    tofi-font-pkg # font
    wl-clipboard
    hyprshot # screenshot tool
    superfile # terminal file manager
    qpwgraph # pipewire patchbay
    pwvucontrol # pipewire volume control
    zenith-nvidia # hardware monitor
    fd # fast 'find' alternative
  ];
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "MrTipson";
    userEmail = "gunfight7.gf@gmail.com";
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
      };
    };
  };
  programs.discocss = {
    enable = true;
    css = "";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.8;
    };
  };
  programs.firefox.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };
  programs.tofi = {
    enable = true;
    settings = {
      background-color = "#000A";
      border-width = 0;
      font = "monospace";
      height = "100%";
      num-results = 5;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
  home.activation.tofi = lib.hm.dag.entryAfter ["writeBoundary"] ''rm -f ~/.cache/tofi-drun'';
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        modules-left = ["hyprland/workspaces" ];
        modules-center = ["hyprland/window"];
        modules-right = ["cpu" "temperature#cpu" "memory" "wireplumber" "clock" "custom/power"];
        cpu = {
          format = "  {}%";
        };
        "temperature#cpu" = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        };
        memory = {
          format = "   {percentage}%";
        };
        "hyprland/window" = {
          separate-outputs = true;
          icon = true;
        };
        clock = {
          format = "{:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#1bf902' background='#063800'><b>{}</b></span>";
            };
          };
        };
        wireplumber = {
          format = "   {volume}%";
          format-muted = "";
          on-click = "pwvucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "qpwgraph";
          tooltip = false;
          max-volume = 150;
          scroll-step = 0.2;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          menu = "on-click";
          menu-file = ./power_menu.xml;
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
      }
    ];
    style = ./style.css; # env GTK_DEBUG=interactive waybar -s nixos/users/mrtipson/style.css
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      "$mod" = "SUPER";
      bind = [ # nix-shell -p wev --run "wev"
        "$mod, F, exec, uwsm app -- kitty"
        "Control Alt, Delete, exit, "
        "$mod, R, exec, uwsm app -- $(tofi-drun --font ${tofi-font})"
        "$mod, T, exec, tofi-run --font ${tofi-font} --require-match=false --prompt-text='execute command: ' | xargs -r uwsm app -- kitty --hold"
        "$mod, C, killactive,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        ", Print, exec, hyprshot -m region --clipboard-only"
        "$mod, Print, exec, hyprshot -m window --clipboard-only"
        "$mod, s, exec, uwsm app -- kitty superfile"
        "$mod, v, exec, bash -c \"wl-paste > $(${../../modules/home-manager/tofi-recursive-file.sh} --font ${tofi-font} --prompt-text='save clipboard to: ')\""
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );
      monitor = [ # hyprctl monitors 
        "HDMI-A-3, 1920x1080, 0x0, 1"
        "DVI-D-1, 1920x1080, 1920x20, 1"
        ", preferred, auto, 1" # catch all for random monitors
      ];
    };
    extraConfig = ''
      input {
        kb_layout = si
        numlock_by_default = true
      }
    '';
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };
    style = ./swaync.css;
  };
  systemd.user.services.polkit-soteria = { # nixpkgs/nixos/modules/security/soteria.nix
    Unit = {
      Description = "Soteria, Polkit authentication agent for any desktop environment";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.soteria}/bin/soteria";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tipson/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
