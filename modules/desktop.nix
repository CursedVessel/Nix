{ config, pkgs, ... }:

{
  # --- COSMIC DESKTOP ---
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # --- GAMING (Steam) ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports for P2P transfers
  };

  # Ensure Gamemode is there for performance
  programs.gamemode.enable = true;

  # --- CLEANUP (Disable KDE) ---
  # We explicitly disable these to prevent conflicts with COSMIC
  services.xserver.enable = false;
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  # --- EXTRAS ---
  # Flatpak is useful for the COSMIC App Store
  services.flatpak.enable = true;
}
