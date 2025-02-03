{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.default = {
      # places.sqlite can get corrupted
      # sqlite3 .mozilla/firefox/<profile>/places.sqlite
      # delete from moz_places;
      search = {
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        force = true;
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        container-tabs-sidebar # add this to extension style: .container .container-tab { padding-left: 20px; }
      ];
      # browser toolbox - enable in devtools settings
      userChrome = ''
        #TabsToolbar,
        #sidebar-header {
          visibility: collapse !important;
        }
      '';
      # about:debugging#/runtime/this-firefox - inspect extension
      userContent = with config.lib.stylix.colors.withHashtag; /* css */ ''
        /* extension: container tabs sidebar */
        @-moz-document url("moz-extension://68bb6098-7287-4cef-87f2-a622fd5c5aeb/sidebar/sidebar.html") {
          .container .container-tab {
            padding-left: 20px !important;
          }
          #pinned-tabs {
            background: ${base03};
          }
          .container-tabs {
            padding-inline-start: 0 !important;
          }
          .container-actions .container-action:hover,
          .container-tab-close:hover,
          .container-tab-action:hover {
            background-color: ${base04} !important;
          }
          .container-tabs li:not(:last-child) .container-tab {
            border-bottom: none !important;
          }
          :root {
            --color-background: ${base00} !important;
            --color-text: ${base05} !important;
            --color-accent: ${base04} !important;
            --color-hover:${base02} !important;
            --color-focus: ${base02} !important;
            --color-default-container: ${base05} !important;
            --color-container-background: ${base01} !important;
            --color-container-border: ${base0D} !important;
            --color-tab-background: ${base00} !important;
            --color-close: ${base05} !important;
            --color-icon: ${base05} !important;
          }
        }
      '';
      settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # userChrome.css
          "devtools.chrome.enabled" = true; # browser console
          # Performance settings
          "gfx.webrender.all" = true; # Force enable GPU acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
      };
      containersForce = true;
      containers = {
        "NixOS" = {
          color = "blue";
          icon = "chill";
          id = 1;
        };
        "Projects" = {
          color = "toolbar";
          icon = "briefcase";
          id = 2;
        };
        "General 1" = {
          color = "turquoise";
          icon = "circle";
          id = 3;
        };
        "General 2" = {
          color = "yellow";
          icon = "circle";
          id = 4;
        };
        "Shopping" = {
          color = "pink";
          icon = "cart";
          id = 5;
        };
        "Dangerous" = {
          color = "red";
          icon = "fingerprint";
          id = 6;
        };
      };
    };
  };
}
