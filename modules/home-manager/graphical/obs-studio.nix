{ pkgs, lib, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-text-pthread
      obs-replay-source
      obs-freeze-filter
      obs-scale-to-sound
      obs-pipewire-audio-capture
    ];
  };
}
