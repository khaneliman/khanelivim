{ lib, inputs, ... }:
{
  imports = lib.optional (inputs.git-hooks-nix ? flakeModule) inputs.git-hooks-nix.flakeModule;

  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    lib.optionalAttrs (inputs.git-hooks-nix ? flakeModule) {
      pre-commit = {
        check.enable = false;

        settings.hooks = {
          # keep-sorted start block=yes newline_separated=no
          actionlint.enable = true;
          clang-tidy.enable = true;
          deadnix = {
            enable = true;

            settings = {
              edit = true;
            };
          };
          eslint = {
            enable = true;
            package = pkgs.eslint_d;
          };
          luacheck.enable = true;
          pre-commit-hook-ensure-sops.enable = true;
          statix = {
            enable = true;
            # Only staged changes
            pass_filenames = true;
            entry = "${lib.getExe pkgs.bash} -c 'for file in \"$@\"; do ${lib.getExe pkgs.statix} check \"$file\"; done' --";
          };
          treefmt.enable = true;
          typos = {
            enable = true;
            excludes = [ "generated/*" ];
          };
          # keep-sorted end
        };
      };
    };
}
