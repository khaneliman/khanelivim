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
    package = pkgs.khanelivim.blink-cmp;
    luaConfig.pre = # lua
      ''
        require('blink.compat').setup({debug = true})
      '';

    settings = {
      appearance = {
        nerd_font_variant = "mono";
        use_nvim_cmp_as_default = true;
      };
      highlight = {
        use_nvim_cmp_as_default = true;
      };
      keymap = {
        preset = "enter";
        "<A-Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<A-S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
      };
      completion = {
        accept.auto_brackets.enabled = true;
        menu = {
          draw = {
            columns = [
              {
                __unkeyed-1 = "label";
                __unkeyed-2 = "label_description";
                gap = 1;
              }
              {
                __unkeyed-1 = "kind_icon";
                __unkeyed-2 = "kind";
              }
            ];
          };
        };
        ghost_text = {
          enabled = true;
        };
      };
      signature = {
        enabled = true;
        border = "rounded";
      };
      sources = {
        completion = {
          enabled_providers = [
            "lsp"
            "buffer"
            "path"
          ];
        };
      };
      trigger = {
        signature_help = {
          enabled = true;
        };
      };
      windows.documentation = {
        auto_show = true;
        border = "rounded";
      };
    };
  };

  plugins.lsp.capabilities = # lua
    ''
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    '';

}
