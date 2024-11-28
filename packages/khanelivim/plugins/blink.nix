{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = lib.mkIf config.plugins.blink-cmp.enable [ pkgs.khanelivim.blink-compat ];

  plugins.blink-cmp = {
    enable = true;
    luaConfig.pre = # lua
      ''
        require('blink.compat').setup({debug = true})
      '';

    settings = {
      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "mono";
      };
      sources = {
        completion = {
          enabled_providers = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };
    };
  };
}
