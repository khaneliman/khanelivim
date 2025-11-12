{
  config,
  lib,
  ...
}:
let
  # Helper to create toggle keymaps for faster features
  mkFasterToggle = feature: key: desc: {
    mode = "n";
    inherit key;
    action.__raw = ''
      function()
        local enabled_var = "faster_${lib.toLower feature}_enabled"
        if vim.g[enabled_var] == false then
          vim.cmd('FasterEnable${feature}')
          vim.g[enabled_var] = true
        else
          vim.cmd('FasterDisable${feature}')
          vim.g[enabled_var] = false
        end
        vim.notify(string.format("Faster ${desc} %s", bool2str(vim.g[enabled_var])), "info")
      end
    '';
    options = {
      desc = "Toggle ${desc}";
    };
  };
in
{
  keymaps =
    lib.optionals config.plugins.faster.enable [
      # Global toggles
      (mkFasterToggle "AllFeatures" "<leader>uxa" "All Features")
      (mkFasterToggle "Bigfile" "<leader>uxb" "Bigfile Behavior")
      (mkFasterToggle "Fastmacro" "<leader>uxm" "Fastmacro Behavior")

      # Core feature toggles (always available with faster)
      (mkFasterToggle "Lsp" "<leader>uxl" "LSP")
      (mkFasterToggle "Treesitter" "<leader>uxt" "Treesitter")
      (mkFasterToggle "Syntax" "<leader>uxs" "Syntax")
      (mkFasterToggle "Matchparen" "<leader>uxp" "Matchparen")
      (mkFasterToggle "Vimopts" "<leader>uxy" "Vimopts")
      (mkFasterToggle "Filetype" "<leader>uxv" "Filetype")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.illuminate.enable) [
      (mkFasterToggle "Illuminate" "<leader>uxi" "Illuminate")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.indent-blankline.enable) [
      (mkFasterToggle "Indentblankline" "<leader>uxI" "Indent Blankline")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.noice.enable) [
      (mkFasterToggle "Noice" "<leader>uxn" "Noice")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.lualine.enable) [
      (mkFasterToggle "Lualine" "<leader>uxu" "Lualine")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.bufferline.enable) [
      (mkFasterToggle "Bufferline" "<leader>uxo" "Bufferline")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.gitsigns.enable) [
      (mkFasterToggle "Gitsigns" "<leader>uxg" "Gitsigns")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.mini-indentscope.enable) [
      (mkFasterToggle "MiniIndentscope" "<leader>uxd" "Mini Indentscope")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.blink-indent.enable) [
      (mkFasterToggle "BlinkIndent" "<leader>uxd" "Blink Indent")
    ]
    ++ lib.optionals (config.plugins.faster.enable && config.plugins.snacks.enable) [
      (mkFasterToggle "Snacks" "<leader>uxk" "Snacks")
    ];

  plugins.which-key.settings.spec = lib.mkIf config.plugins.faster.enable [
    {
      __unkeyed-1 = "<leader>ux";
      group = "Faster Toggles";
      icon = "󰔡";
    }
  ];
}
