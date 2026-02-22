{ config, lib, ... }:
{
  plugins.blink-pairs = {
    # blink-pairs documentation
    # See: https://github.com/saghen/blink.pairs
    enable = config.khanelivim.editor.autopairs == "blink-pairs";

    lazyLoad.settings = {
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };

  };

  keymaps = lib.mkIf config.plugins.blink-pairs.enable [
    {
      key = "<leader>uep";
      mode = "n";
      action.__raw = ''
        function ()
          vim.b.blink_pairs = vim.b[0].blink_pairs == false
          vim.notify(string.format("Buffer AutoPairs %s", bool2str(vim.b[0].blink_pairs ~= false), "info"))
        end'';
      options.desc = "Buffer AutoPairs toggle";
    }
    {
      key = "<leader>ueP";
      mode = "n";
      action.__raw = ''
        function ()
          vim.g.blink_pairs = vim.g.blink_pairs == false
          vim.notify(string.format("Global AutoPairs %s", bool2str(vim.g.blink_pairs ~= false), "info"))
        end'';
      options.desc = "Global AutoPairs toggle";
    }
  ];
}
