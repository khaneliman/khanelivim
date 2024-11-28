{
  plugins.blink-cmp = {
    enable = true;

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
