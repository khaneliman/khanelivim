{ config, lib, ... }:
{
  plugins = {
    mini-pairs.enable = true;
  };

  keymaps = lib.mkIf config.plugins.mini-pairs.enable [
    {
      key = "<leader>up";
      mode = "n";
      action.__raw = ''
        function ()
          vim.b.minipairs_disable = not vim.b.minipairs_disable
          vim.notify(string.format("Buffer AutoPairs %s", bool2str(not vim.b[0].minipairs_disable), "info"))
        end'';
      options = {
        desc = "Buffer AutoPairs toggle";
      };
    }
    {
      key = "<leader>uP";
      mode = "n";
      action.__raw = ''
        function ()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          vim.notify(string.format("Global AutoPairs %s", bool2str(not vim.g.minipairs_disable), "info"))
        end'';
      options = {
        desc = "Global AutoPairs toggle";
      };
    }
  ];
}
