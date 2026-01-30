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

      # ZED EDITOR
      zed-editor

      # FONTS
      nerd-fonts.jetbrains-mono

      # NIX LSP & FORMATTING
      nixd
      nil
      nixfmt # <--- CHANGED: Was "nixfmt-rfc-style"
    ]
    ++ lib.optionals isLinux [
      discord
      firefox
      # COSMIC App Store
      popsicle
      # Gaming
      protonplus
    ]
    ++ lib.optionals isDarwin [
      raycast
    ];

  # --- FONT CONFIG ---
  fonts.fontconfig.enable = true;

  # --- XDG CONFIGURATION (Dotfiles) ---
  xdg.configFile = {

    # 1. FASTFETCH
    "fastfetch/config.jsonc" = {
      source = ../dotfiles/fastfetch/config.jsonc;
    };

    # 2. ZED EDITOR
    "zed/settings.json".text = builtins.toJSON {
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = "One Dark";
      languages = {
        Nix = {
          language_servers = [ "nixd" "nil" ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = ["--quiet" "--stdin"];
            };
          };
        };
      };
      lsp = {
        nixd = {
          settings = {
            nixpkgs = { expr = "import <nixpkgs> {}"; };
            formatting = { command = [ "nixfmt" ]; };
            options = {
              nixos = { expr = "(builtins.getFlake \"/home/${username}/nixos\").nixosConfigurations.mahito.options"; };
            };
          };
        };
      };
    };
  };

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

  # --- HOME FILES (Root level) ---
  home.file = {
    # 1. STARSHIP
    ".config/starship.toml".text = ''
      add_newline = false
      [username]
      disabled = true
    '';

    # 2. WALLPAPERS
    "Pictures/wallpapers" = {
      source = ../assets/wallpapers;
      recursive = true;
    };
  };
}
