{ config, lib, ... }:
{
  plugins.markview =
    let
      # markview.nvim documentation
      # See: https://github.com/OXY2DEV/markview.nvim
      filetypes = [
        "Avante"
        "codecompanion"
        "latex"
        "markdown"
        "md"
        "norg"
        "org"
        "quarto"
        "rmd"
        "typst"
        "vimwiki"
      ];
    in
    {
      enable = lib.elem "markview" config.khanelivim.text.markdownRendering;

      lazyLoad.settings = {
        ft = filetypes;
        cmd = "Markview";
      };

      settings = {
        # Fancy comment rendering which can conflict with todo-comments
        comment.enable = lib.elem "markview" config.khanelivim.text.patterns;

        preview = {
          inherit filetypes;

          ignore_buftypes = [ "nofile" ];

          condition.__raw = ''
            function (buffer)
               local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

               if ft == "snacks_picker_preview" then
                    return false;
               end

               if bt == "nofile" and (ft == "Avante" or ft == "codecompanion") then
                    return true;
               end

               return nil;
            end
          '';
        };
      };
    };

  keymaps = lib.mkIf config.plugins.markview.enable [
    {
      mode = "n";
      key = "<leader>uem";
      action = "<cmd>Markview toggle<CR>";
      options = {
        desc = "Toggle Markdown Preview";
      };
    }
  ];
}
