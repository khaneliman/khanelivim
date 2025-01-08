{ config, ... }:
{
  plugins = {
    clangd-extensions = {
      inherit (config.plugins.treesitter) enable;
      enableOffsetEncodingWorkaround = true;

      ast = {
        roleIcons = {
          type = "";
          declaration = "";
          expression = "";
          specifier = "";
          statement = "";
          templateArgument = "";
        };
        kindIcons = {
          compound = "";
          recovery = "";
          translationUnit = "";
          packExpansion = "";
          templateTypeParm = "";
          templateTemplateParm = "";
          templateParamObject = "";
        };
      };
    };
  };
}
