{ config, pkgs, lib, ... }:

{
  ####################################################################
  # services.nix
  ####################################################################

  # Tailscale system daemon
  services.tailscale = {
    enable = true;
  };

  # Printing (CUPS)
  services.printing.enable = lib.mkDefault true;

  # Audio system
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  # OpenSSH server
  services.openssh = {
    enable = lib.mkDefault false;
    settings.PermitRootLogin = "no";
  };

  # Networking firewall
  networking.firewall.enable = lib.mkDefault false;

  system.activationScripts.servicesNote.text = ''
    echo "Applied services.nix defaults."
  '';
}
