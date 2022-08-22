{
  description = "diegodox's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    neovim,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Plugin must be same as input name
    plugins = [
    ];


    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    };
  in rec {
    apps.${system} = rec {
      nvim = {
        type = "app";
        program = "${packages."${system}".default}/bin/nvim";
      };
      default = nvim;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [packages.${system}.neovim-diegodox];
    };

    overlays.default = final: prev: {
      neovim-diegodox = packages.${system}.neovim-diegodox;
      neovimPlugins = pkgs.neovimPlugins;
    };

    packages.${system} = rec {
      default = neovim-diegodox;
      neovim-diegodox =
        pkgs.wrapNeovim pkgs.neovim-unwrapped {
        };
    };
  };
}
