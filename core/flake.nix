{
  description = "neovim wrap";

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
    neovim-nightly-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        neovim-nightly-overlay.overlay
      ];
    };
  in {
    inherit system pkgs;

    # build neovim with configuration
    buildNvim = configure:
      pkgs.wrapNeovim pkgs.neovim-unwrapped {
        inherit configure;
      };

    # build function of vim plugin which have name in inputs
    buildPlug = name: plugin:
      pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = plugin;
      };

    # built plugin list
    buildPlugList = plugins:
      pkgs.lib.attrsets.mapAttrsToList
      (name: value: (self.buildPlug name value)) plugins;
  };
}
