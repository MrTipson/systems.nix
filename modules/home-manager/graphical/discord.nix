{ pkgs, config, ... }:
{
  home.packages = [ pkgs.discord ];

  xdg.configFile."discord/custom.css".text = with config.lib.stylix.colors.withHashtag; /*css*/ ''
    @import url("https://mrtipson.github.io/DiscordCSS/css/server-bar.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/server-folders.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/channel-sidebar-utils.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/base.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/base16.css");

    .theme-light, .theme-dark {
      --base00: ${base00};
      --base01: ${base01};
      --base02: ${base02};
      --base03: ${base03};
      --base04: ${base04};
      --base05: ${base05};
      --base06: ${base06};
      --base07: ${base07};
      --base08: ${base08};
      --base09: ${base09};
      --base0A: ${base0A};
      --base0B: ${base0B};
      --base0C: ${base0C};
      --base0D: ${base0D};
      --base0E: ${base0E};
      --base0F: ${base0F};

      --color-main: rgb(68, 152, 255);
      --window-opacity: ${builtins.toString config.stylix.opacity.applications};
    }
  '';
  # TODO inject
}
