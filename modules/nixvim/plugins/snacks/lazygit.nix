{
  config,
  lib,
  ...
}:
let
  isEnabled = lib.elem "snacks-lazygit" config.khanelivim.git.integrations;
in
{
  dependencies.lazygit.enable = lib.mkDefault isEnabled;

  plugins = {
    snacks = {
      settings = {
        lazygit.enabled = isEnabled;
      };
    };
  };

  keymaps = lib.mkIf isEnabled [
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
