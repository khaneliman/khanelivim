{
  inputs,
  lib,
  self,
  ...
}:
let
  mkNixvimConfig =
    {
      system,
      pkgs ? null,
      profile ? "standard",
    }:
    let
      sharedNixpkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config = {
          allowAliases = false;
          allowUnfree = true;
          permittedInsecurePackages = [
            # FIXME: pnpm 9 unsafe ignore for stylelint-lsp.
            "pnpm-9.15.9"
          ];
        };
      };
      hasNixvimPackages = lib.hasAttr system inputs.nixvim.packages;
      nixvimPkgs = if pkgs == null then sharedNixpkgs else pkgs;
    in
    inputs.nixvim.lib.evalNixvim {
      inherit system;

      extraSpecialArgs = {
        inherit inputs system self;
      };

      modules = [
        self.nixvimModules.default
        {
          enableMan = lib.mkDefault hasNixvimPackages;
          nixpkgs.pkgs = lib.mkDefault nixvimPkgs;
          nixpkgs.config = lib.mkForce { };
          khanelivim.profile = profile;
        }
      ]
      # FIXME: nixpkgs' optimized `pandoc` lost Lua support on aarch64-darwin
      # after the staging-next 2026-06-27 merge:
      # https://github.com/NixOS/nixpkgs/commit/1e94a0307f544377e2f2332daa7fca2833a1adc3
      # Keep this scoped to Nixvim's man docs and remove it once `pkgs.pandoc`
      # reports `+lua` on Darwin again.
      ++ lib.optional nixvimPkgs.stdenv.isDarwin {
        flake = lib.mkForce (
          inputs.nixvim
          // {
            packages = inputs.nixvim.packages // {
              ${system} = inputs.nixvim.packages.${system} // {
                man-docs = inputs.nixvim.packages.${system}.man-docs.override {
                  pandoc = nixvimPkgs.haskellPackages.pandoc-cli;
                };
              };
            };
          }
        );
      };
    };
in
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = false;
    checks.enable = false;
  };

  flake = {
    nixvimModules.default = ../modules/nixvim;
    lib = {
      inherit mkNixvimConfig;
      mkNixvimPackage = args: (mkNixvimConfig args).config.build.package;
      mkNixvimTest = args: (mkNixvimConfig args).config.build.test;
    };
  };

  perSystem =
    { pkgs, system, ... }:
    let
      defaultConfig = mkNixvimConfig { inherit pkgs system; };
    in
    {
      nixvimConfigurations = {
        # Recommended default profile
        khanelivim = defaultConfig;
      };

      checks.khanelivim = defaultConfig.config.build.test;
    };
}
