{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    windsurf-nvim = {
      # windsurf.nvim documentation
      # See: https://github.com/Exafunction/windsurf.nvim
      enable = builtins.elem "windsurf" config.khanelivim.ai.plugins;

      settings = {
        enable_chat = true;

        tools = {
          curl = lib.getExe pkgs.curl;
          gzip = lib.getExe pkgs.gzip;
          uname = lib.getExe' pkgs.coreutils "uname";
          uuidgen = lib.getExe' pkgs.util-linux "uuidgen";
        };
      };
    };
  };

  keymaps = lib.mkIf (builtins.elem "windsurf" config.khanelivim.ai.plugins) [
    {
      mode = "n";
      key = "<leader>aC";
      action = "<cmd>Codeium Chat<CR>";
      options = {
        desc = "Codeium Chat";
      };
    }
  ];
}
