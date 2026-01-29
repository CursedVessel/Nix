{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system (Required for SDDM)
  services.xserver.enable = true;

  # --- PLASMA LOGIN MANAGER CONFIGURATION ---
  # KDE Plasma 6 uses SDDM as its engine.
  # We force the 'breeze' theme so it acts as the native "Plasma Login".
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # Uses Wayland for the login screen itself
    theme = "breeze";      # <--- This is key for the "Plasma Login" look
  };

  # Enable the KDE Plasma 6 Desktop Environment
  services.desktopManager.plasma6.enable = true;

  # X11 Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Steam (Must be enabled at system level for controller/network support)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Fonts
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      dejavu_fonts
      liberation_ttf
    ];
  };

  system.activationScripts.desktopNote.text = ''
    echo "Applied desktop.nix: KDE Plasma 6 + Native Breeze Login."
  '';
}
