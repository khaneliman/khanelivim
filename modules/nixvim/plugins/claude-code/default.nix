{
  pkgs,
  ...
}:
{
  extraPackages = [
    pkgs.claude-code
  ];

  # TODO: upstream module
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.claude-code-nvim;
      optional = true;
    }
  ];

  plugins = {
    lz-n = {
      enable = true;
      plugins = [
        {
          __unkeyed-1 = "claude-code.nvim";
          cmd = [ "ClaudeCode" ];
          after = # Lua
            ''
              function()
                require ("claude-code").setup({
                  window = { position = "vertical"}
                })
              end
            '';
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>ClaudeCode<CR>";
      options = {
        desc = "Claude Code";
      };
    }
  ];
}
