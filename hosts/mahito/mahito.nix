{ config, pkgs, lib, ... }:

{
  networking.hostName = "Mahito";

  # Mahito Specifics (Intel CPU)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Tailscale
  services.tailscale.enable = true;

  system.activationScripts.hostNote.text = ''
    echo "Active Host: MAHITO (Intel/Nvidia)"
  '';
}
