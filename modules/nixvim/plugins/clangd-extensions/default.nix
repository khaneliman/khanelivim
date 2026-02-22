{ config, ... }:
{
  plugins = {
    clangd-extensions = {
      # clangd-extensions.nvim documentation
      # See: https://sr.ht/~chinmay/clangd_extensions.nvim
      lazyLoad.settings.cmd = [
        "ClangdAST"
        "ClangdTypeHierarchy"
        "ClangdSymbolInfo"
        "ClangdMemoryUsage"
        "ClangdSwitchSourceHeader"
      ];

      inherit (config.plugins.treesitter) enable;
      enableOffsetEncodingWorkaround = true;

      settings = {
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
  };
}
