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
  # masterLuaPackages = nixpkgs-master-packages.luaPackages;
  # masterVimPlugins = nixpkgs-master-packages.vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    claude-code
    github-copilot-cli
    # TODO: Remove after hitting channel
    ;

  kulala-core = prev.kulala-core.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "0.37.0";

      src = prev.fetchFromGitHub {
        owner = "mistweaverco";
        repo = "kulala-core";
        tag = "v${finalAttrs.version}";
        hash = "sha256-rqfxp+i2o2DA8vle8yr+C6TzHcF2Q7kwYkW2VLMaKw0=";
      };

      node_modules = previousAttrs.node_modules.overrideAttrs {
        inherit (finalAttrs) version src;
        outputHash = "sha256-y/Wl87g9BEok6DbUIKxMhp9rhSBpfFDQt5BSiUJzpW4=";
      };
    }
  );

  # Dormant until a Lua package needs a targeted override.
  # luaPackages = prev.luaPackages // {
  #   #
  #   # Specific package overlays need to go in here to not get ignored
  #   # Pull faster updates from nixpkgs-master with:
  #   # inherit (masterLuaPackages) some-package;
  #   #
  # };

  vimPlugins = prev.vimPlugins.extend (
    _self: super: {
      #
      # Specific package overlays need to go in here to not get ignored
      # Pull faster updates from nixpkgs-master with:
      # inherit (masterVimPlugins) some-plugin;
      #

      # inherit (masterVimPlugins) ts-comments-nvim;
      nvim-java = super.nvim-java.overrideAttrs {
        dependencies = [
          super.nui-nvim
          super.nvim-dap
        ];
      };
    }
  );
}
