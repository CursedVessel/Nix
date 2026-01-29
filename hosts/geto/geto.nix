{ pkgs, ... }:
{
  # MacOS System Defaults
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllFiles = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "Geto (M4)";
  };

  # Enable Rosetta (allows x86 apps to run on M4)
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # User Setup
  users.users.cosmic = {
    name = "cosmic";
    home = "/Users/cosmic";
  };

  # System Packages (Mac specific)
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Homebrew (Optional but recommended for Mac-only binary apps)
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "visual-studio-code"
      "discord"
      "spotify"
      "ghostty" # Great new terminal for Mac
    ];
  };

  system.stateVersion = 5;
}
