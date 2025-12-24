{ config, lib, ... }:
{
  plugins.todo-comments = {
    enable = lib.elem "todo-comments" config.khanelivim.text.patterns;

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
          + lib.optionalString (config.khanelivim.picker.tool == "fzf") ''
            require('lz.n').trigger_load('fzf-lua')
          ''
          + lib.optionalString config.plugins.trouble.enable ''
            require('lz.n').trigger_load('trouble.nvim')
          ''
          + lib.optionalString (config.khanelivim.picker.tool == "snacks") ''
            require('lz.n').trigger_load('snacks.nvim')
          ''
          + ''
            end
          ''
        );
        keys = lib.mkIf (config.khanelivim.picker.tool == "snacks") [
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
        ++ lib.optional (config.khanelivim.picker.tool == "fzf") "TodoFzfLua"
        ++ lib.optional config.plugins.trouble.enable "TodoTrouble";
      };
    };

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      # Fallback if snacks picker not enabled
      todoFzfLua = lib.mkIf (config.khanelivim.picker.tool == "fzf") {
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
