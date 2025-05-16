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
        ];
      };
    };
}
