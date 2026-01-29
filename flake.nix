{
  description = "Jujutsu Kaisen Homelab: Mahito, Itadori, Geto, & Toji";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }: {

    # --- MACOS (Geto) ---
    darwinConfigurations."Geto" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/geto/geto.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cosmic = import ./shared/home.nix;
        }
      ];
    };

    # --- NIXOS (Linux) ---
    nixosConfigurations = {

      # ITADORI (Desktop)
      itadori = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix                # Imports shared modules from ./modules/
          ./hosts/itadori/itadori.nix
          ./hosts/itadori/hardware-configuration.nix
          ./modules/nvidia.nix               # Explicitly import Nvidia module here
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cosmic = import ./shared/home.nix;
          }
        ];
      };

      # MAHITO (Laptop)
      mahito = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/mahito/mahito.nix
          ./hosts/mahito/hardware-configuration.nix
          ./modules/nvidia.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cosmic = import ./shared/home.nix;
          }
        ];
      };

      # TOJI (Server)
      toji = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # We do NOT import ./configuration.nix here because Toji shouldn't have desktop.nix
          # Instead, we import only the specific modules Toji needs:
          ./modules/system.nix
          ./modules/users.nix
          ./modules/services.nix
          ./modules/boot.nix
          ./modules/system-packages.nix

          ./hosts/toji/toji.nix
          # ./hosts/toji/hardware-configuration.nix  # Uncomment when generated

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cosmic = import ./shared/home.nix;
          }
        ];
      };

    };
  };
}
