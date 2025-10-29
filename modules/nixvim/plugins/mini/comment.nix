{ config, lib, ... }:
{
  plugins = lib.mkIf (lib.elem "mini-comment" config.khanelivim.text.comments) {
    mini = {
      enable = true;

      modules = {
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
      };
    };
  };
}
