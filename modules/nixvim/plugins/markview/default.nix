{ config, lib, ... }:
{
  plugins.markview =
    let
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

          ignore_buftypes = [ ];

          condition.__raw = ''
            function (buffer)
               local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

               if bt == "nofile" and (ft == "Avante" or ft == "codecompanion") then
                    return true;
               elseif bt == "nofile" then
                    return false;
               else
                    return true;
               end
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
