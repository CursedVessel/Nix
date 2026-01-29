{ config, pkgs, lib, ... }:

{
  # A small modular file for boot-related settings.
  # This module sets sane defaults for EFI + systemd-boot and uses the
  # latest kernel package set by default.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest available kernel package set by default.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # REMOVED: hardware.enableAllMemoryControllers (deprecated/removed option)
}
