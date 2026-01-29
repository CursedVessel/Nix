{ config, pkgs, lib, ... }:

{
  networking.hostName = "Itadori";

  # FIX: "services.power" is not a valid option.
  # We use power-profiles-daemon instead.
  # Since this is a desktop, we can disable aggressive power saving.
  services.power-profiles-daemon.enable = false;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Activation Note
  system.activationScripts.hostNote.text = ''
    echo "Active Host: ITADORI (Ryzen/Nvidia)"
  '';
}
