{
  config,
  lib,
  ...
}:
{
  plugins = {
    claude-code = {
      enable = true;
      lazyLoad.settings.cmd = [ "ClaudeCode" ];

      settings = {
        window = {
          position = "vertical";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.claude-code.enable [
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
