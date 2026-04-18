{ flake }:
_final: prev:
let
  nixpkgs-master-packages = import flake.inputs.nixpkgs-master {
    inherit (prev.stdenv) system;
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };
  # my-packages = flake.packages.${prev.stdenv.system};
  inherit (nixpkgs-master-packages) luaPackages vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    claude-code
    codex
    gemini
    github-copilot-cli
    opencode

    # TODO: Remove after hitting channel
    ;

  luaPackages = luaPackages // {
    #
    # Specific package overlays need to go in here to not get ignored
    #
  };

  vimPlugins = vimPlugins.extend (
    _self: super: {
      #
      # Specific package overlays need to go in here to not get ignored
      #
      # TODO: remove after upstreamed
      # https://github.com/nvim-java/nvim-java/pull/487
      nvim-java = super.nvim-java.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            name = "nvim-java-pr-487.patch";
            url = "https://patch-diff.githubusercontent.com/raw/nvim-java/nvim-java/pull/487.patch";
            hash = "sha256-qe89H0pNd0qOuvilrhWfZqHrqy3PV/E/wguEUad0nEA=";
          })
        ];
      });
    }
  );
}
