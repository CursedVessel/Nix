{ config, pkgs, ... }:

{
  imports = [
    # Core System Modules (Now correctly pointing to the modules folder)
    ./modules/system.nix
    ./modules/users.nix            # Ensuring users.nix is imported
    ./modules/services.nix
    ./modules/boot.nix
    ./modules/system-packages.nix

    # NOTE: desktop.nix is imported here.
    # If you want a headless server (Toji), you might want to move this import
    # to the specific host files (mahito/itadori) instead.
    # For now, I'm leaving it here to match your previous setup.
    ./modules/desktop.nix
  ];

  # Keep stateVersion here for safety
  system.stateVersion = "25.11";
}
