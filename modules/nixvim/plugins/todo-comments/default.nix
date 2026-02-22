{ config, lib, ... }:
let
  isSnacks = config.khanelivim.picker.tool == "snacks";
  isFzf = config.khanelivim.picker.tool == "fzf";
  isLazy = config.plugins.todo-comments.lazyLoad.enable;
in
{
  plugins.todo-comments = {
    # todo-comments.nvim documentation
    # See: https://github.com/folke/todo-comments.nvim
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
          + lib.optionalString isFzf ''
            require('lz.n').trigger_load('fzf-lua')
          ''
          + lib.optionalString config.plugins.trouble.enable ''
            require('lz.n').trigger_load('trouble.nvim')
          ''
          + lib.optionalString isSnacks ''
            require('lz.n').trigger_load('snacks.nvim')
          ''
          + ''
            end
          ''
        );

        keys = lib.mkIf (isLazy && isSnacks) [
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
        ++ lib.optional isFzf "TodoFzfLua"
        ++ lib.optional config.plugins.trouble.enable "TodoTrouble";
      };
    };

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      # Fallback if snacks picker not enabled
      todoFzfLua = lib.mkIf isFzf {
        key = "<leader>ft";
        keywords = [
          "TODO"
          "FIX"
          "FIXME"
        ];
      };
    };
  };

  keymaps = lib.mkIf (config.plugins.todo-comments.enable && !isLazy && isSnacks) [
    {
      mode = "n";
      key = "<leader>ft";
      action = ''<CMD>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<CR>'';
      options = {
        desc = "Find TODOs";
      };
    }
  ];
}
