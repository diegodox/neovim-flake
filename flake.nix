{
  description = "diegodox's NeoVim config";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;

  outputs = { self, nixpkgs, flake-utils, neovim-nightly-overlay, ... }:
    with flake-utils.lib;
    eachSystem defaultSystems (system:

      let
        pkgs = nixpkgs.legacyPackages.${system};
        neovim-unwrapped = pkgs.neovim-unwrapped;
      in

      rec{

        ## neovim specify config
        packages.nvim_withconfig = pkgs.writeShellScriptBin
          "mynvim"
          "${neovim-unwrapped}/bin/nvim -u config/init.lua";


        ## neovim with config
        packages.mynvim = pkgs.symlinkJoin {
          name = "mynvim";
          paths = [ packages.config packages.nvim_withconfig pkgs.neovim-unwrapped ];
        };


        ## Pure neovim (-u NONE)
        packages.nullvim = pkgs.writeShellScriptBin "nullvim"
          ''
            ${neovim-unwrapped}/bin/nvim --clean "$@"
          '';

        ## Derivation which contains neovim config files.
        ## We can reference this derivation whenever we need config.
        packages.config = pkgs.stdenvNoCC.mkDerivation {
          name = "neovim-config-files";
          src = self + "/config";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out
            cp -r $src $out/config
          '';
        };
      }
    );
}
