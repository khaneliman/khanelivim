{
  config,
  lib,
  ...
}:
{
  plugins.telescope = {
    extensions = {
      live-grep-args.enable = true;
    };

    keymaps = lib.mkIf (!config.plugins.fzf-lua.enable) {
      "<leader>fw" = lib.mkIf (!config.plugins.telescope.extensions.live-grep-args.enable) {
        action = "live_grep";
        options.desc = "Live grep";
      };
    };
  };

  keymaps = lib.mkIf config.plugins.telescope.enable [
    (lib.mkIf
      (config.plugins.telescope.extensions.live-grep-args.enable && !config.plugins.fzf-lua.enable)
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>Telescope live_grep_args<CR>";
        options = {
          desc = "Live grep (args)";
        };
      }
    )
  ];
}
