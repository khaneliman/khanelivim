{ config, lib, ... }:
{
  plugins.luasnip = {
    enable =
      !config.plugins.mini.enable
      || (config.plugins.mini.enable && (!lib.hasAttr "snippets" config.plugins.mini.modules));
    settings = lib.mkIf config.plugins.blink-cmp.enable {
      snippets = {
        expand.__raw = "function(snippet) require('luasnip').lsp_expand(snippet) end";
        active.__raw = ''
          function(filter)
            if filter and filter.direction then
              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end
        '';
        jump.__raw = "function(direction) require('luasnip').jump(direction) end";
      };
    };
  };
}
