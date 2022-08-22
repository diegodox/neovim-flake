{
  description = "diegodox's NeoVim config";

  inputs = {
    core.url = "path:./core";
    plugin.url = "path:./plugin";
  };

  outputs = {
    self,
    core,
    plugin,
    ...
  }: let
    inherit (core) system pkgs buildNvim;
    plugins = core.buildPlugList plugin.plugins;
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
      neovim-diegodox = buildNvim {
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
}
