{ config, lib, ... }:
{
  plugins.todo-comments = {
    enable = true;

    lazyLoad.settings = {
      # keys =
      #   lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      #     [
      #       {
      #         __unkeyed-1 = "<leader>ft";
      #         __unkeyed-2 = ''<CMD>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<CR>'';
      #         desc = "Find TODOs";
      #       }
      #     ];
      cmd = [
        "TodoFzfLua"
        "TodoLocList"
        "TodoQuickFix"
        "TodoTelescope"
        "TodoTrouble"
      ];
    };

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      # Fallback if snacks picker not enabled
      todoFzfLua =
        lib.mkIf
          (config.plugins.fzf-lua.enable
            # && (
            #   !config.plugins.snacks.enable
            #   || (config.plugins.snacks.enable && !lib.hasAttr "picker" config.plugins.snacks.settings)
            # )
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
