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

    keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
      "<leader>fw" = lib.mkIf (!config.plugins.telescope.extensions.live-grep-args.enable) {
        action = "live_grep";
        options.desc = "Live grep";
      };
    };
  };

  keymaps = lib.mkIf (config.khanelivim.picker.engine == "telescope") [
    (lib.mkIf config.plugins.telescope.extensions.live-grep-args.enable {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>Telescope live_grep_args<CR>";
      options = {
        desc = "Live grep (args)";
      };
    })
  ];
}
