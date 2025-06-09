{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "Khanelivim development shell";
        meta.description = "Shell environment for modifying this Nix configuration";
        packages = with pkgs; [
          deadnix
          nixd
          nixfmt-rfc-style
          statix
          python3
          (pkgs.writeShellScriptBin "new-plugin" ''
            if [ $# -ne 2 ]; then
              echo "Usage: new-plugin <plugin-name> <template-type>"
              echo "Template types: custom, custom-lazy, nixvim"
              exit 1
            fi
            ${./new-plugin.py} "$1" "$2"
          '')
        ];

        shellHook = ''
          echo "Khanelivim development shell"
          echo "Available commands:"
          echo "  new-plugin <name> <type> - Generate new plugin template"
          echo "  deadnix -e              - Check for unused Nix code"
          echo "  statix fix .            - Fix Nix linting issues"
          echo "  nixfmt **/*.nix         - Format Nix files"
        '';
      };
    };
}
