{ config, pkgs, lib, ... }:

{
  networking.hostName = "Toji";

  # Server Networking
  networking.networkmanager.enable = lib.mkForce false;
  networking.firewall.enable = true;

  # SSH is critical for Toji
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Minimal Packages for Server
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    htop
    git
    docker
    docker-compose
  ];

  virtualisation.docker.enable = true;

  # --- HEADLESS CONFIG ---
  services.xserver.enable = false;

  system.stateVersion = "25.11";

  # =================================================================
  # DUMMY CONFIGURATION (REQUIRED FOR FLAKE CHECK)
  # =================================================================
  # Since you haven't generated hardware-configuration.nix for Toji
  # yet, we must provide a fake root drive so 'nix flake check'
  # doesn't fail.
  #
  # DELETE THESE LINES when you actually install NixOS on Toji!
  # =================================================================
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # We also need a dummy bootloader definition if one isn't
  # provided by your shared boot.nix (which usually uses systemd-boot).
  # This is just to satisfy the evaluator.
}
