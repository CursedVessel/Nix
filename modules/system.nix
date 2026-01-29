{ config, pkgs, lib, ... }:

{
  ####################################################################
  # system.nix
  #
  # General system-wide settings that are not host-specific. This module
  # is intended to contain non-desktop-specific defaults: networking,
  # localization, Nix settings, GC, and system-level housekeeping.
  #
  # Host-specific values (like `networking.hostName` or special kernel
  # overrides) should be declared in `nixos/hosts/<host>.nix`.
  ####################################################################

  # Networking
  # Use NetworkManager by default for desktop/laptop convenience.
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Nix settings & experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # GC and auto-upgrade
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  system.autoUpgrade.enable = true;

  # Allow unfree packages globally (keep as before)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  # Security helpers used by audio and other desktop services
  security.rtkit.enable = true;

  # Minimal default shell for system accounts if needed (not the user shell)
  # This does not change the user's shell. Per-user shells are set in users.nix.
  environment.systemPackages = with pkgs; [
    # Keep this intentionally minimal since most desktop apps will be moved to home.packages.
    # Add any essential system-level utilities you want available to all users here.
    cacert
    curl
    wget
    gnupg
  ];

  # Keep the system.stateVersion set at the top-level configuration file (configuration.nix),
  # but if you want to override it here, you can. We intentionally do not force it here.
  #
  # Notes / guidance for other modules:
  # - Desktop-specific configuration (X11/Wayland, display manager, DE) belongs in modules/desktop.nix
  # - Services (pipewire, tailscaled system service, printing) belong in modules/services.nix
  # - Users and per-user metadata belong in modules/users.nix
  # - Per-host overrides live under hosts/*.nix and are imported by configuration.nix
}
