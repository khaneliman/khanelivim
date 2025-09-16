{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    claude-code = {
      enable = true;
      package = pkgs.vimPlugins.claude-code-nvim.overrideAttrs {
        patches = [
          ./unlist-buffer.patch
        ];
      };
      lazyLoad.settings.cmd = [
        "ClaudeCode"
        "ClaudeCodeContinue"
        "ClaudeCodeResume"
        "ClaudeCodeVerbose"
      ];

      settings = {
        window = {
          position = "vertical";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.claude-code.enable [
      {
        __unkeyed-1 = "<leader>ac";
        group = "Claude Code";
        icon = "";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.claude-code.enable [
    {
      key = "<leader>act";
      action = "<cmd>ClaudeCode<CR>";
      options = {
        desc = "Toggle Claude";
      };
    }
    {
      key = "<leader>acc";
      action = "<cmd>ClaudeCodeContinue<CR>";
      options = {
        desc = "Continue Claude";
      };
    }
    {
      key = "<leader>acr";
      action = "<cmd>ClaudeCodeResume<CR>";
      options = {
        desc = "Resume Claude";
      };
    }
    {
      key = "<leader>acv";
      action = "<cmd>ClaudeCodeVerbose<CR>";
      options = {
        desc = "Verbose Claude";
      };
    }
  ];
}
