{
  plugins = {
    compiler.enable = true;
  };

  # TODO: add keymaps
  # keymaps = lib.mkIf config.plugins.codeium-nvim.enable [
  #   {
  #     mode = "n";
  #     key = "<leader>uc";
  #     action = ":Codeium Chat<CR>";
  #     options = {
  #       desc = "Codeium Chat";
  #       silent = true;
  #     };
  #   }
  # ];
}
