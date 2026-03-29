{
  perSystem =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      manualPackages = with pkgs; [
        nixd
        python3
        (writeShellScriptBin "new-plugin" ''
          if [ $# -ne 2 ]; then
            echo "Usage: new-plugin <plugin-name> <template-type>"
            echo "Template types: custom, custom-lazy, nixvim"
            exit 1
          fi
          ${./new-plugin.py} "$1" "$2"
        '')
      ];

      packages = lib.unique (manualPackages ++ config.pre-commit.settings.enabledPackages);
    in
    {
      devShells.default = pkgs.mkShell {
        name = "Khanelivim development shell";
        meta.description = "Shell environment for modifying this Nix configuration";
        inherit packages;

        shellHook = ''
          ${config.pre-commit.installationScript}

          echo "🚀 Khanelivim development shell"
          echo ""
          echo "🔧 Available commands:"
          echo "  new-plugin <name> <type> - Generate new plugin template"
          echo "  deadnix -e               - Check for unused Nix code"
          echo "  statix fix .             - Fix Nix linting issues"
          echo "  nix fmt .                - Format tree"
          echo ""
          echo "📦 Available packages:"
          ${lib.concatMapStringsSep "\n" (
            pkg: ''echo "  - ${pkg.pname or pkg.name or "unknown"} (${pkg.version or "unknown"})"''
          ) packages}
        '';
      };
    };
}
