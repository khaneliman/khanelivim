{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    windsurf-nvim = {
      enable = !config.plugins.copilot-lua.enable;

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

  keymaps = lib.mkIf config.plugins.windsurf-nvim.enable [
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
