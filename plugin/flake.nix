{
  description = "neovim plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # plugins
    vim-code-dark = {
      url = "github:tomasiser/vim-code-dark";
      flake = false;
    };
    fix-cursor-hold = {
      url = "github:antoinemadec/FixCursorHold.nvim";
      flake = false;
    };
    crazy8 = {
      url = "github:zsugabubus/crazy8.nvim";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    vim-code-dark,
    fix-cursor-hold,
    crazy8,
    gitsigns,
    treesitter,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    filterAttrs = lib.attrsets.filterAttrs;
    mapAttrsToList = lib.attrsets.mapAttrsToList;
    plugins = filterAttrs (name: value: name != "nixpkgs") inputs;
  in {
    inherit plugins;

    names = mapAttrsToList (name: value: name) plugins;
  };
}
