{ config, lib, ... }:
{
  plugins = {
    # friendly-snippets documentation
    # See: https://github.com/rafamadriz/friendly-snippets
    friendly-snippets.enable = true;
  };

  plugins.luasnip.luaConfig.post =
    lib.mkIf (config.plugins.friendly-snippets.enable && config.khanelivim.editor.snippet == "luasnip")
      ''
        require("luasnip.loaders.from_vscode").lazy_load()

        local ls = require("luasnip")
        ls.filetype_extend("typescript", { "angular", "remix-ts" })
        ls.filetype_extend("typescriptreact", { "angular", "remix-ts" })
        ls.filetype_extend("html", { "angular" })
        ls.filetype_extend("cs", { "unity" })
        ls.filetype_extend("cpp", { "unreal" })
      '';
}
