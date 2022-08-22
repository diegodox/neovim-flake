{
  description = "diegodox's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # plugins
    vim-code-dark = {
      url = "github:tomasiser/vim-code-dark";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim,
    vim-code-dark,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Plugin list must be same as input name
    plugin-names = [
      "vim-code-dark"
    ];


    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
    };

    # build function of vim plugin which have name in inputs
    buildPlug = name:
      pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
      };

    # built plugin list
    plugins = map (name: buildPlug name) plugin-names;
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
      neovim-diegodox = pkgs.wrapNeovim pkgs.neovim-unwrapped {
        configure = {
          customRC = ''
            colorscheme codedark
          '';
          packages.myVimPackage = {
            start = plugins;
            opt = [];
          };
        };
      };
    };
  };
}
