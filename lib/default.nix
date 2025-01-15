{
  lib,
}:
lib.makeExtensible (
  self:
  let
    # Used when importing parts of our lib
    call = lib.callPackageWith {
      inherit call lib self;
    };
  in
  {
    files = call ./files.nix { };

    # Top-level helper aliases:
    inherit (self.files)
      readAllFiles
      ;

  }
)
