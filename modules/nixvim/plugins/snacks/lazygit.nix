{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        lazygit.enabled = lib.elem "snacks-lazygit" config.khanelivim.git.integrations;
      };
    };
  };

  keymaps = lib.mkIf (lib.elem "snacks-lazygit" config.khanelivim.git.integrations) [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<CR>";
      options = {
        desc = "Open lazygit";
      };
    }
  ];
}
