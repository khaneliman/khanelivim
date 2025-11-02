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
}
