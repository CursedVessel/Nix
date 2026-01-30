{ pkgs, lib, ... }:

let
  username = "cosmic";
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "25.11";

  # --- PACKAGES ---
  home.packages = with pkgs;
    [
      # SHARED TOOLS
      fastfetch
      unrar
      unzip
      zsh
      starship
      fzf
      btop
      ripgrep
      bat

      # NIX LSP TOOLS
      nixd
      nil
    ]
    ++ lib.optionals isLinux [
      discord
      firefox
      kdePackages.ark
      kdePackages.okular
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.filelight
      popsicle
      protonplus
    ]
    ++ lib.optionals isDarwin [
      raycast
    ];

  # --- GIT CONFIG ---
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "CursedVessel";
        email = "hxnterwelch@gmail.com";
      };
    };
  };

  # --- ZSH CONFIG ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      ll = "ls -lah";
      rebuild = if isDarwin
        then "nix run nix-darwin -- switch --flake .#Geto"
        else "sudo nixos-rebuild switch --flake .";
    };

    initContent = ''
      eval "$(starship init zsh)"
    '';
  };

  # --- FILE MANAGEMENT & ASSETS ---
  home.file = {
    # 1. Global: Starship Config
    ".config/starship.toml".text = ''
      add_newline = false
      [username]
      disabled = true
    '';

    # 2. WALLPAPERS (Added This Section)
    # Recursively links ~/nixos/assets/wallpapers -> ~/Pictures/wallpapers
    "Pictures/wallpapers" = {
      source = ../assets/wallpapers;
      recursive = true;
    };

  } // lib.optionalAttrs isLinux {
    # 3. Linux Only: Kate LSP Config
    ".config/kate/lspclient/settings.json".text = builtins.toJSON {
      servers = {
        nix = {
          command = ["nixd"];
          root = "";
          url = "https://github.com/nix-community/nixd";
          highlightingModeRegex = "^Nix$";
        };
      };
    };
  };
}
