{ pkgs, config, ... }:
{
  stylix.targets.swaync.enable = false;
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 20;
      control-center-margin-bottom = 20;
      control-center-margin-right = 20;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };
    style = with config.lib.stylix.colors.withHashtag; /*css*/ ''
      @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
      @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};
      @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
      @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
    ''
    + (with config.stylix; /*css*/ ''
      .control-center {
        padding: 5px 10px;
        border-radius: 0px;
        background: @base00;
        box-shadow: 0px 0px 2px 2px @base0D;
      }
      button,
      switch {
        background: @base01;
        border: 1px solid @base03;
      }
      slider {
        background: @base02;
      }
      button:hover,
      switch:hover {
        border: 1px solid @base0D;
      }
      switch:checked {
        background: @base0D;
      }

      scrolledwindow {
        padding-top: 20px;
        padding-right: 20px;
      }

      .notification {
        color: @base0E;
        background: transparent;
        border: 0;
        margin-bottom: 10px;
      }

      .notification-background {
        padding: 0;
        background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, @base03 50%, rgba(0,0,0,0));
      }

      .notification-default-action {
        color: inherit;
        background: @base00;
        padding: 5px 10px;
        border: 1px solid @base03;
        border-left: 3px solid currentColor;
        border-radius: 0px;
        opacity: ${builtins.toString opacity.popups};
      }

      .notification-default-action:hover {
        border: 1px solid @base0D;
        border-left: 3px solid currentColor;
      }

      .notification.critical { color: @base08; }
      .notification.low { color: @base0A; }

      .notification-content {
        padding: 5px 10px;
      }

      .image {
        margin-right: 15px;
      }
    '');
  };
}
