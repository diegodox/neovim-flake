{
  pkgs,
  lib ? pkgs.lib,
  ...
}: {config}: let
  neovimPlugins = pkgs.neovimPlugins;

  vimOptions = lib.evalModules {
    modules = [
      config
    ];

    specialArgs = {
      inherit pkgs;
    };
  };
in
  pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias = true;
    vimAlias = true;
    configure = {

    };
  }
