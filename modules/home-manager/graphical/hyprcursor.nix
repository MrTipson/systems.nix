{ pkgs, config, ... }:
{
  home.pointerCursor = {
    hyprcursor = {
      enable = true;
      size = config.stylix.cursor.size;
    };
  };
}
