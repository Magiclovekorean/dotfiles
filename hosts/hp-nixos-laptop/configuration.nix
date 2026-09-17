{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "hp-nixos-laptop";

  # Firmware advertises TPM2 (MSFT0101) but tpm_crb probe fails; systemd then
  # waits ~90s for /dev/tpm0 before sysinit.target (graphical login).
  systemd.tpm2.enable = false;

  # DaVinci Resolve needs an OpenCL ICD to detect the GPU (Intel Iris Xe).
  # Without it Resolve reports "GPU not available".
  hardware.graphics.extraPackages = with pkgs; [ intel-compute-runtime ];
}
