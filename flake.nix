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

    pluginOverlay = lib.buildPluginOverlay;

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        pluginOverlay
        inputs.neovim-nightly-overlay.overlay
        (final: prev: {
          rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
        })
      ];
    };

    lib = import ./lib {inherit pkgs inputs plugins;};

    neovimBuilder = lib.neovimBuilder;
  in rec {
    apps.${system} = rec {
      nvim = {
        type = "app";
        program = "${packages."${system}".default}/bin/nvim";
      };
      default = nvim;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [packages.${system}.nevoim-diegodox];
    };

    overlays.default = final: prev: {
      inherit neovimBuilder;
      neovim-diegodox = packages.${system}.neovim-diegodox;
      neovimPlugins = pkgs.neovimPlugins;
    };

    packages.${system} = rec {
      default = neovim-diegodox;
      neovim-diegodox = neovimBuilder {
        config = {
        };
      };
    };
  };
}
