{ config, lib, ... }:
{
  extraFiles = lib.mkIf (config.khanelivim.editor.snippet != null) (
    let
      snippetsDir = ./snippets;

      allFiles = lib.filesystem.listFilesRecursive snippetsDir;
      jsonFiles = lib.filter (p: lib.hasSuffix ".json" (toString p)) allFiles;

      mkEntry =
        p:
        let
          relPath = lib.removePrefix "${toString snippetsDir}/" (toString p);
        in
        lib.nameValuePair "snippets/${relPath}" {
          source = p;
        };
    in
    lib.listToAttrs (map mkEntry jsonFiles)
  );
}
