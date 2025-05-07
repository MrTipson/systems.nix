{config, pkgs, ...}:
{
  boot = {
    # nvidia-uvm is required for CUDA applications
    kernelModules = [ "nvidia-uvm" ];
  };

  hardware = {
    nvidia.modesetting.enable = true;
  };
}
