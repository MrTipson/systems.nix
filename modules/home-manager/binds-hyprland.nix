{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [ # nix-shell -p wev --run "wev"
      "$mod, F, exec, uwsm app -- kitty"
      "Control Alt, Delete, exit, "
      "$mod, R, exec, uwsm app -- $(tofi-drun)"
      "$mod, T, exec, tofi-run --require-match=false --prompt-text='execute command: ' | xargs -r uwsm app -- kitty --hold"
      "$mod, C, killactive,"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      ", Print, exec, hyprshot -m region --clipboard-only"
      "$mod, Print, exec, hyprshot -m window --clipboard-only"
      "$mod, s, exec, uwsm app -T -- superfile"
      "$mod, h, exec, uwsm app -T -- zenith"
      "$mod, v, exec, bash -c \"wl-paste > $(${../../modules/home-manager/graphical/tofi-recursive-file.sh} --prompt-text='save clipboard to: ')\""
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
  };
}
