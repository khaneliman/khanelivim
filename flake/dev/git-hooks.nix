{ lib, inputs, ... }:
{
  imports = lib.optional (inputs.git-hooks-nix ? flakeModule) inputs.git-hooks-nix.flakeModule;

  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      mkParseHook =
        hookName: nixPackage:
        let
          nixInstantiate = "${nixPackage}/bin/nix-instantiate";
          nixStore = "${nixPackage}/bin/nix-store";
          parseScript = pkgs.writeShellScriptBin "pre-commit-${hookName}-parse" ''
            set -euo pipefail

            if [ "$#" -eq 0 ]; then
              exit 0
            fi

            cache_root="''${XDG_CACHE_HOME:-$HOME/.cache}/khanelivim"
            mkdir -p "$cache_root"
            workdir="$(mktemp -d "$cache_root/pre-commit-${hookName}-parse.XXXXXX")"
            trap 'rm -rf "$workdir"' EXIT
            raw_parse_log="$workdir/nix-parse.raw.log"
            parse_log="$workdir/nix-parse.log"
            store_init_failed=0
            parse_failed=0

            filter_parse_log() {
              : > "$parse_log"
              while IFS= read -r line || [ -n "$line" ]; do
                case "$line" in
                  "warning: unknown experimental feature "*|"warning: unknown setting "*)
                    ;;
                  *)
                    printf "%s\n" "$line" >> "$parse_log"
                    ;;
                esac
              done < "$raw_parse_log"
            }

            : > "$raw_parse_log"

            export NIX_STORE_DIR="$workdir/store"
            export NIX_STATE_DIR="$workdir/state"

            mkdir -p "$NIX_STATE_DIR" "$NIX_STORE_DIR"
            if ! ${nixStore} --init 2>> "$raw_parse_log"; then
              store_init_failed=1
            fi

            if [ "$store_init_failed" -eq 0 ]; then
              for file in "$@"; do
                if ! ${nixInstantiate} --parse "$file" > /dev/null 2>> "$raw_parse_log"; then
                  parse_failed=1
                fi
              done
            fi

            filter_parse_log

            if [ -s "$parse_log" ]; then
              cat "$parse_log" >&2
              if [ "$store_init_failed" -ne 0 ]; then
                echo "Failed to initialize temporary Nix store." >&2
              elif [ "$parse_failed" -ne 0 ]; then
                echo "Parse failed in nix-instantiate." >&2
              else
                echo "Failing due to warnings in stderr" >&2
              fi
              exit 1
            fi

            if [ "$store_init_failed" -ne 0 ]; then
              echo "Failed to initialize temporary Nix store." >&2
              exit 1
            fi

            if [ "$parse_failed" -ne 0 ]; then
              echo "Parse failed in nix-instantiate." >&2
              exit 1
            fi
          '';
        in
        {
          enable = true;
          files = "\\.nix$";
          pass_filenames = true;
          package = nixPackage;
          entry = lib.getExe parseScript;
        };
    in
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
          lix-parse = mkParseHook "lix" pkgs.lixPackageSets.latest.lix;
          luacheck.enable = true;
          nix-parse = mkParseHook "nix" pkgs.nixVersions.latest;
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
            excludes = [ "^generated/" ];
          };
          # keep-sorted end
        };
      };
    };
}
