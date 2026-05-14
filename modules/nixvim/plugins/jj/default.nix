{
  config,
  lib,
  ...
}:
let
  cfg = config.plugins.jj;
in
{
  config = lib.mkMerge [
    {
      plugins.jj = {
        enable = lib.mkDefault (builtins.elem "jj" config.khanelivim.jj.integrations);

        settings = {
          terminal.cursor_render_delay = lib.mkDefault 10;

          cmd = {
            describe.editor = {
              type = lib.mkDefault "buffer";
              keymaps.close = lib.mkDefault [
                "q"
                "<Esc>"
                "<C-c>"
              ];
            };
            bookmark.prefix = lib.mkDefault "feat/";
            keymaps = {
              log = {
                checkout = lib.mkDefault "<CR>";
                describe = lib.mkDefault "d";
                diff = lib.mkDefault "<S-d>";
                abandon = lib.mkDefault "<S-a>";
                fetch = lib.mkDefault "<S-f>";
              };
              status = {
                open_file = lib.mkDefault "<CR>";
                restore_file = lib.mkDefault "<S-x>";
              };
              close = lib.mkDefault [
                "q"
                "<Esc>"
              ];
            };
          };

          highlights.modified.fg = lib.mkDefault "#89ddff";
          picker = lib.mkIf (config.plugins.snacks.enable or false) {
            snacks = lib.mkDefault { };
          };
        };

        lazyLoad = lib.mkIf config.plugins.lz-n.enable {
          settings.cmd = lib.mkDefault [ "J" ];
        };
      };
    }

    (lib.mkIf cfg.enable {
      autoCmd = [
        {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
          callback.__raw = ''
            function(args)
              local bufnr = args.buf
              if vim.b[bufnr].khanelivim_jj_keymaps then
                return
              end

              local path = vim.api.nvim_buf_get_name(bufnr)
              local dir = path ~= "" and vim.fn.fnamemodify(path, ":p:h") or vim.fn.getcwd()
              if vim.fn.finddir(".jj", dir .. ";") == "" then
                return
              end

              vim.b[bufnr].khanelivim_jj_keymaps = true

              local opts = function(desc)
                return { buffer = bufnr, desc = desc }
              end

              local map = function(mode, key, fn, desc)
                vim.keymap.set(mode, key, function()
                  ${lib.optionalString (
                    config.plugins.lz-n.enable && config.plugins.jj.lazyLoad.enable
                  ) ''require("lz.n").trigger_load("${lib.getName cfg.package}")''}
                  fn()
                end, opts(desc))
              end

              map("n", "<leader>jd", function() require("jj.cmd").describe() end, "Describe")
              map("n", "<leader>jl", function() require("jj.cmd").log() end, "Log")
              map("n", "<leader>je", function() require("jj.cmd").edit() end, "Edit")
              map("n", "<leader>jn", function() require("jj.cmd").new() end, "New")
              map("n", "<leader>js", function() require("jj.cmd").status() end, "Status")
              map("n", "<leader>jS", function() require("jj.cmd").squash() end, "Squash")
              map("n", "<leader>ju", function() require("jj.cmd").undo() end, "Undo")
              map("n", "<leader>jy", function() require("jj.cmd").redo() end, "Redo")
              map("n", "<leader>jr", function() require("jj.cmd").rebase() end, "Rebase")
              map("n", "<leader>jbc", function() require("jj.cmd").bookmark_create() end, "Create bookmark")
              map("n", "<leader>jbd", function() require("jj.cmd").bookmark_delete() end, "Delete bookmark")
              map("n", "<leader>jbm", function() require("jj.cmd").bookmark_move() end, "Move bookmark")
              map("n", "<leader>ja", function() require("jj.cmd").abandon() end, "Abandon")
              map("n", "<leader>jf", function() require("jj.cmd").fetch() end, "Fetch")
              map("n", "<leader>jp", function() require("jj.cmd").push() end, "Push")
              map("n", "<leader>jpr", function() require("jj.cmd").open_pr() end, "Open PR")
              map("n", "<leader>jpl", function() require("jj.cmd").open_pr({ list_bookmarks = true }) end, "Open PR (List)")
              map("n", "<leader>gdf", function() require("jj.diff").open_diff() end, "Diff current buffer")
              map("n", "<leader>gdF", function() require("jj.diff").open_hsplit() end, "Diff current buffer (Split)")
              map("n", "<leader>gj", function() require("jj.picker").status() end, "Status picker")
              map("n", "<leader>jh", function() require("jj.picker").file_history() end, "History picker")
              map("n", "<leader>jL", function() require("jj.cmd").log({ revisions = "all()" }) end, "Log all")
              map("n", "<leader>jt", function()
                require("jj.cmd").j("tug")
                require("jj.cmd").log({})
              end, "Tug")
            end
          '';
        }
      ];
    })
  ];
}
