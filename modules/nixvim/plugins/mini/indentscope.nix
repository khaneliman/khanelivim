{ config, lib, ... }:
{
  autoCmd = lib.mkIf (config.khanelivim.ui.indentGuides == "mini-indentscope") [
    {
      event = [ "FileType" ];
      pattern = [
        "help"
        "alpha"
        "dashboard"
        "neo-tree"
        "Trouble"
        "trouble"
        "lazy"
        "mason"
        "notify"
        "toggleterm"
        "lazyterm"
        "snacks_dashboard"
      ];
      callback.__raw = ''
        function()
          vim.b.miniindentscope_disable = true
        end
      '';
    }
  ];

  plugins.mini-indentscope = lib.mkIf (config.khanelivim.ui.indentGuides == "mini-indentscope") {
    enable = true;
  };

  keymaps = lib.mkIf (config.khanelivim.ui.indentGuides == "mini-indentscope") [
    {
      mode = "n";
      key = "<leader>ui";
      action.__raw = ''
        function()
          vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
          vim.notify(string.format("Mini Indentscope %s", bool2str(not vim.g.miniindentscope_disable)), "info")
        end
      '';
      options.desc = "Mini Indentscope toggle";
    }
  ];
}
