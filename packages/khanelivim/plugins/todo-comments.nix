{ config, lib, ... }:
{
  plugins.todo-comments = {
    enable = true;

    lazyLoad.settings.event = [
      "BufEnter"
    ];

    keymaps = {
      todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xq";
      todoFzfLua = lib.mkIf config.plugins.fzf-lua.enable {
        key = "<leader>ft";
        keywords = [
          "TODO"
          "FIX"
          "FIXME"
        ];
      };
      todoTelescope = lib.mkIf (config.plugins.telescope.enable && !config.plugins.fzf-lua.enable) {
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
