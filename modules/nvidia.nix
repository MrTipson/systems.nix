{config, pkgs, ...}:
{
  boot = {
    # nvidia-uvm is required for CUDA applications
    kernelModules = [ "nvidia-uvm" ];
    blacklistedKernelModules = [ "nouveau" ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
