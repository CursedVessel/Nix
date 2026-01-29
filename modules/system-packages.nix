{ config, pkgs, lib, ... }:

{
  ####################################################################
  # system-packages.nix
  #
  # Minimal system-wide packages. Most desktop applications have been
  # intentionally moved into the user's `home.packages` (Home Manager)
  # so they are managed per-user rather than globally.
  #
  # Keep this list small: only essential, system-level utilities that
  # should be present for all users belong here.
  ####################################################################

  environment.systemPackages = with pkgs; [
    # TLS certificates and basic network tools are useful to have system-wide
    cacert
    curl
    wget

    # Core utilities that are harmless to provide globally
    coreutils
    bash
    gnupg
  ];

  # If you later decide to provide a small set of admin tools for all users,
  # add them here. Otherwise prefer per-user management via Home Manager.
}
