{ pkgs, lib, ... }:
{
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    # gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  
  environment.systemPackages = with pkgs; [
    protonup
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
     "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # then do this:
  # protonup -d "$STEAM_EXTRA_COMPAT_TOOLS_PATHS"

  # you might run into issues with vulkan
  # try running games with dx11 (e.g. -x11)
}
