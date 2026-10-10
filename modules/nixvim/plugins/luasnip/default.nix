{ config, ... }:
{
  plugins.luasnip = {
    # LuaSnip documentation
    # See: https://github.com/L3MON4D3/LuaSnip
    enable = config.khanelivim.editor.snippet == "luasnip";
    lazyLoad.settings.event = "InsertEnter";
  };
}
