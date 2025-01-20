{
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    default = ../modules/nixvim;
  };

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations = {
        khanelivim = inputs.nixvim.lib.evalNixvim {
          inherit system;

          extraSpecialArgs = {
            inherit inputs system self;
          };

          modules = [
            self.nixvimModules.default
          ];
        };
      };
    };
}
