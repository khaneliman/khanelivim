{
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (inputs) pre-commit-hooks-nix;
  inherit (lib) getExe;
in
pre-commit-hooks-nix.lib.${pkgs.system}.run {
  src = ./.;
  hooks =
    let
      excludes = [
        "flake.lock"
        "CHANGELOG.md"
      ];
      fail_fast = true;
      verbose = true;
    in
    {
      deadnix = {
        enable = true;

        settings = {
          edit = true;
        };
      };

      git-cliff = {
        enable = false;
        inherit excludes fail_fast verbose;

        always_run = true;
        description = "pre-push hook for git-cliff";
        entry = "${getExe pkgs.${namespace}.git-cliff}";
        language = "system";
        stages = [ "pre-push" ];
      };

      luacheck.enable = true;

      nixfmt = {
        enable = true;
        package = pkgs.nixfmt-rfc-style;
      };

      pre-commit-hook-ensure-sops.enable = true;

      statix.enable = true;
      # treefmt.enable = true;
    };
}
