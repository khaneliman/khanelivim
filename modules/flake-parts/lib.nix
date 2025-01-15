{ lib, ... }:
{
  # FIXME: inf recursion
  # Expose lib as a flake-parts module arg
  # _module.args = {
  #   khanelivim-lib = self.lib.khanelivim;
  # };

  # Create internal lib
  flake.lib = {
    khanelivim = lib.makeOverridable (import ../../lib) {
      inherit lib;
    };
  };
}
