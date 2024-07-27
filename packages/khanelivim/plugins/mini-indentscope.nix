{ config, lib, ... }:
{

  autoCmd = lib.mkIf (lib.hasAttr "indentscope" config.plugins.mini.modules) [
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
      ];
      callback.__raw = # Lua
        ''
          function()
            vim.b.miniindentscope_disable = true
          end
        '';
    }
  ];
  plugins = {
    mini = {
      enable = true;

      modules = {
        indentscope = { };
      };
    };
  };
}
