{ config, lib, ... }:
{
  plugins.todo-comments = {
    enable = true;

    lazyLoad = {
      # NOTE: Plugin highlighting feature not used until loaded.
      # Will just not lazy load since I love the highlighting feature.
      enable = false;
      settings = {
        # TODO: see if we can split this up somehow
        before.__raw = lib.mkIf config.plugins.lz-n.enable (
          ''
            function()
          ''
          + lib.optionalString config.plugins.fzf-lua.enable ''
            require('lz.n').trigger_load('fzf-lua')
          ''
          + lib.optionalString config.plugins.trouble.enable ''
            require('lz.n').trigger_load('trouble.nvim')
          ''
          + lib.optionalString config.plugins.telescope.enable ''
            require('lz.n').trigger_load('telescope')
          ''
          + lib.optionalString (config.khanelivim.picker.engine == "snacks") ''
            require('lz.n').trigger_load('snacks.nvim')
          ''
          + ''
            end
          ''
        );
        keys = lib.mkIf (config.khanelivim.picker.engine == "snacks") [
          {
            __unkeyed-1 = "<leader>ft";
            __unkeyed-2 = ''<CMD>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<CR>'';
            desc = "Find TODOs";
          }
        ];
        cmd = [
          "TodoLocList"
          "TodoQuickFix"
        ]
        ++ lib.optional config.plugins.fzf-lua.enable "TodoFzfLua"
        ++ lib.optional config.plugins.telescope.enable "TodoTelescope"
        ++ lib.optional config.plugins.trouble.enable "TodoTrouble";
      };
    };

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      # Fallback if snacks picker not enabled
      todoFzfLua = lib.mkIf (config.khanelivim.picker.engine == "fzf") {
        key = "<leader>ft";
        keywords = [
          "TODO"
          "FIX"
          "FIXME"
        ];
      };
      # Fallback if no others enabled
      todoTelescope = lib.mkIf (config.khanelivim.picker.engine == "telescope") {
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
