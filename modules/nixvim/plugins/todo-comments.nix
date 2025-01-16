{ config, lib, ... }:
{
  plugins.todo-comments = {
    enable = true;

    lazyLoad.settings.event = [
      "BufEnter"
    ];

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      # Fallback is snacks picker not enabled
      todoFzfLua =
        lib.mkIf
          (
            config.plugins.fzf-lua.enable
            && (
              !config.plugins.snacks.enable
              || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
            )
          )
          {
            key = "<leader>ft";
            keywords = [
              "TODO"
              "FIX"
              "FIXME"
            ];
          };
      # Fallback if no others enabled
      todoTelescope =
        lib.mkIf
          (
            config.plugins.telescope.enable
            && !config.plugins.fzf-lua.enable
            && (
              !config.plugins.snacks.enable
              || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
            )
          )
          {
            key = "<leader>ft";
            keywords = [
              "TODO"
              "FIX"
              "FIXME"
            ];
          };
    };
  };
}
