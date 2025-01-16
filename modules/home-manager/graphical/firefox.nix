{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.default = {
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
      userChrome = ''
        #TabsToolbar,
        #sidebar-header {
          visibility: collapse !important;
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
