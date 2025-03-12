{
  pkgs,
  ...
}:
{
  extraPlugins = [
    pkgs.vimPlugins.nerdy-nvim
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>f,";
      action = "<CMD>Nerdy<CR>";
      options = {
        desc = "Find Nerd Icons";
      };
    }
  ];
}
