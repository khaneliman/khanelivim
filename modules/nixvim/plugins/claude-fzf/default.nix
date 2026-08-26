{
  config,
  lib,
  ...
}:
{
  plugins.claude-fzf = {
    # claude-fzf needs fzf-lua, which loads only with the fzf picker.
    enable = lib.mkDefault (config.plugins.claudecode.enable && config.plugins.fzf-lua.enable);

    settings = {
      keymaps = {
        files = "<leader>acF";
        grep = "<leader>acg";
        buffers = "<leader>acB";
        git_files = "<leader>acG";
        directory_files = "<leader>acD";
      };

      fzf_opts = {
        preview.border = "rounded";
        winopts.width = 0.7;
      };

      logging.level = "WARN";
    };

    lazyLoad = lib.mkIf config.plugins.lz-n.enable {
      settings.keys = [
        {
          __unkeyed-1 = "<leader>acF";
          desc = "Claude Files";
        }
        {
          __unkeyed-1 = "<leader>acg";
          desc = "Claude Grep";
        }
        {
          __unkeyed-1 = "<leader>acB";
          desc = "Claude Buffers";
        }
        {
          __unkeyed-1 = "<leader>acG";
          desc = "Claude Git Files";
        }
        {
          __unkeyed-1 = "<leader>acD";
          desc = "Claude Directory Files";
        }
      ];
    };
  };
}
