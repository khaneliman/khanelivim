{
  lib,
  ...
}:

let
  inherit (lib) fromJSON;
  inherit (lib.generators) mkLuaInline;
in
{
  # nixpkgs lib helpers for language-bearing strings.
  test_case_lib_language_helpers = {
    luaInlineFullPath = lib.generators.mkLuaInline ''
      vim.api.nvim_set_option_value("number", true, {})
    '';

    luaInlineLibAlias = lib.mkLuaInline "vim.fn.getcwd()";

    luaInlineInherited = mkLuaInline ''
      require("lint").try_lint()
    '';

    parsedJsonLib = lib.fromJSON ''
      {
        "language": "json",
        "enabled": true
      }
    '';

    parsedJsonInherited = fromJSON ''{"compact": true}'';

    parsedTomlLib = lib.fromTOML ''
      language = "toml"
      enabled = true
    '';

    parsedTomlInherited = lib.fromTOML "compact = true";
  };
}
