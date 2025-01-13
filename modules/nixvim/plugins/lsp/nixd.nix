{
  lib,
  pkgs,
  self,
  ...
}:
{
  plugins = {
    lsp = {
      servers = {
        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake "${self}")'';
              system = ''''${builtins.currentSystem}'';
            in
            {
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
              options = {
                nixvim.expr = ''${flake}.packages.${system}.nvim.options'';
                # NOTE: These will be passed in from outside using `.extend` from the flake installing this package
                # nix-darwin.expr = ''${flake}.darwinConfigurations.khanelimac.options'';
                # nixos.expr = ''${flake}.nixosConfigurations.khanelinix.options'';
                # home-manager.expr = ''${nixos.expr}.home-manager.users.type.getSubOptions [ ]'';
              };
            };
        };
      };
    };
  };
}
