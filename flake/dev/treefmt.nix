{ lib, inputs, ... }:
{
  imports = lib.optional (inputs.treefmt-nix ? flakeModule) inputs.treefmt-nix.flakeModule;

  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
      treefmt = {
        flakeCheck = true;
        flakeFormatter = true;

        projectRootFile = "flake.nix";

        programs = {
          # keep-sorted start block=yes newline_separated=no
          # FIXME: broken dependency on darwin
          actionlint.enable = pkgs.stdenv.hostPlatform.isLinux;
          biome = {
            enable = true;
            settings.formatter.formatWithErrors = true;
          };
          clang-format.enable = true;
          deadnix = {
            enable = true;
          };
          deno = {
            enable = true;
            # Using biome for these
            excludes = [
              "*.ts"
              "*.js"
              "*.json"
              "*.jsonc"
            ];
          };
          fantomas.enable = true;
          fish_indent.enable = true;
          gofmt.enable = true;
          isort.enable = true;
          keep-sorted.enable = true;
          nixf-diagnose = {
            enable = true;
            priority = -1;
          };
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
          # TODO: removed package because it wasn't safe enough
          # Should re-visit sometime
          # nufmt.enable = true;
          ruff-check.enable = true;
          ruff-format.enable = true;
          rustfmt.enable = true;
          shfmt = {
            enable = true;
            indent_size = 4;
          };
          statix = {
            enable = true;
            priority = -2;
          };
          stylua.enable = true;
          taplo.enable = true;
          yamlfmt.enable = true;
          # keep-sorted end
        };

        settings = {
          global.excludes = [
            # keep-sorted start
            "*.editorconfig"
            "*.envrc"
            "*.git-blame-ignore-revs"
            "*.gitattributes"
            "*.gitconfig"
            "*.gitignore"
            "*.luacheckrc"
            "*CODEOWNERS"
            "*LICENSE"
            "*flake.lock"
            "assets/*"
            "justfile"
            #keep-sorted end
          ];

          formatter.ruff-format.options = [ "--isolated" ];
          formatter.nixf-diagnose.options = [
            "--auto-fix"
            "--ignore=sema-unused-def-lambda-witharg-formal"
          ];
        };
      };
    };
}
