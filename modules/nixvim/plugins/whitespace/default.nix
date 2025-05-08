{
  lib,
  config,
  ...
}:
{
  plugins.whitespace = {
    enable = true;
    settings = {
      highlight = "DiffDelete";
      ignored_filetypes = [
        "Avante"
        "AvanteInput"
        "TelescopePrompt"
        "Trouble"
        "blink-cmp-documentation"
        "blink-cmp-menu"
        "blink-cmp-signature"
        "checkhealth"
        "copilot-chat"
        "dashboard"
        "fzf"
        "help"
        "ministarter"
        "snacks_dashboard"
      ];
      ignore_terminal = true;
      return_cursor = true;
    };
  };

  keymaps = lib.mkIf config.plugins.whitespace.enable [
    {
      mode = "n";
      key = "<leader>lw";
      action.__raw = "require('whitespace-nvim').trim";
      options = {
        desc = "Whitespace trim";
      };
    }
  ];
}
