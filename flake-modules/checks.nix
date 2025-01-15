{ inputs, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks.nixvim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule {
        inherit pkgs;

        extraSpecialArgs = {
          inherit self system inputs;
        };

        module = {
          imports = [ ../modules/nixvim ];
        };
      };
    };
}
