{ config, pkgs, ... }:

{
  # Allow unfree packages (needed for Steam, Discord, drivers)
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = true;

  users.users.cosmic = {
    isNormalUser = true;
    description = "Hunter Welch";
    createHome = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" ];
    shell = pkgs.zsh;
    initialPassword = "chloe"; # Remember to change this with 'passwd'
  };

  # Enable Zsh system-wide so it works as a login shell
  programs.zsh.enable = true;
}
