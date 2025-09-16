_: {
  perSystem =
    { pkgs, lib, ... }:
    let
      inputGroups = {
        core = {
          description = "Core Nix ecosystem";
          inputs = [
            "nixpkgs"
            "nixpkgs-master"
            "flake-parts"
          ];
        };

        apps = {
          description = "Applications & packages";
          inputs = [
            "nixvim"
            "pkgs-by-name-for-flake-parts"
          ];
        };
      };

      mkUpdateApp =
        name:
        { description, inputs }:
        {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update-${name}";
              meta = {
                mainProgram = "update-${name}";
                description = "Update ${description} inputs";
              };
              text = ''
                set -euo pipefail

                echo "🔄 Updating ${description} inputs..."
                nix flake update ${lib.concatStringsSep " " inputs}

                echo "✅ ${description} inputs updated successfully!"
              '';
            }
          );
          meta.description = "Update ${description} inputs";
        };

      groupApps = lib.mapAttrs mkUpdateApp inputGroups;
    in
    {
      apps = groupApps // {
        update-all = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update-all";
              meta = {
                mainProgram = "update-all";
                description = "Update all flake inputs";
              };
              text = ''
                set -euo pipefail

                echo "🔄 Updating main flake lock..."
                nix flake update

                echo "🔄 Updating dev flake lock..."
                cd flake/dev && nix flake update

                echo "✅ All flake locks updated successfully!"
              '';
            }
          );
          meta.description = "Update all flake inputs including development dependencies";
        };
      };
    };
}
