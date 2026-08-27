{
  inputs,
  lib,
}:
let
  patchesRoot = ../patches;

  localPatches =
    inputName:
    let
      patchDir = patchesRoot + "/${inputName}";
    in
    if builtins.pathExists patchDir then
      map (patchName: patchDir + "/${patchName}") (
        builtins.filter (patchName: lib.hasSuffix ".patch" patchName) (
          builtins.attrNames (builtins.readDir patchDir)
        )
      )
    else
      [ ];

  normalizePatches =
    pkgs: patches:
    let
      patchList = if builtins.isFunction patches then patches pkgs else patches;
      normalizePatch =
        patch:
        if builtins.isAttrs patch && patch ? url then
          let
            fetcher = patch.fetcher or "fetchpatch2";
            fetchPatch = if builtins.isString fetcher then pkgs.${fetcher} else fetcher;
          in
          fetchPatch (removeAttrs patch [ "fetcher" ])
        else
          patch;
    in
    map normalizePatch patchList;

  inputPatches =
    {
      pkgs,
      inputName,
    }:
    let
      patchFile = patchesRoot + "/${inputName}/default.nix";
      fetchedPatches =
        if builtins.pathExists patchFile then
          import patchFile {
            inherit pkgs;
            inherit (pkgs) lib;
          }
        else
          [ ];
    in
    localPatches inputName ++ normalizePatches pkgs fetchedPatches;
in
{
  mkPatchedSource =
    {
      pkgs,
      inputName,
      input ? inputs.${inputName},
    }:
    let
      patches = inputPatches { inherit pkgs inputName; };
    in
    if patches == [ ] then
      input
    else
      pkgs.applyPatches {
        name = "${inputName}-patched";
        src = input;
        inherit patches;
      };
}
