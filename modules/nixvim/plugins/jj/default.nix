{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.plugins.jj;
in
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.jj = {
    enable = lib.mkEnableOption "jj" // {
      default = builtins.elem "jj" config.khanelivim.jj.integrations;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "jj" {
      default = "jj-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        terminal = {
          cursor_render_delay = 10;
        };
        cmd = {
          describe = {
            editor = {
              type = "buffer";
              keymaps = {
                close = [
                  "q"
                  "<Esc>"
                  "<C-c>"
                ];
              };
            };
          };
          bookmark = {
            prefix = "feat/";
          };
          keymaps = {
            log = {
              checkout = "<CR>";
              describe = "d";
              diff = "<S-d>";
              abandon = "<S-a>";
              fetch = "<S-f>";
            };
            status = {
              open_file = "<CR>";
              restore_file = "<S-x>";
            };
            close = [
              "q"
              "<Esc>"
            ];
          };
        };
        highlights = {
          modified = {
            fg = "#89ddff";
          };
        };
        # Setup snacks as a picker if snacks is enabled
        picker = lib.mkIf (config.plugins.snacks.enable or false) {
          snacks = { };
        };
      };
      description = ''
        Configuration for jj.

        See <https://github.com/NicolasGB/jj.nvim>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    __depPackages.jj.default = "jujutsu";
    dependencies.jj.enable = lib.mkDefault true;

    extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) ''
      require('jj').setup(${lib.generators.toLua { } cfg.settings})
    '';

    extraPlugins = [
      {
        plugin = cfg.package;
        optional = config.plugins.lz-n.enable;
      }
    ];

    plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
      {
        __unkeyed-1 = "jj.nvim";
        cmd = [ "J" ];
        after = ''
          function()
            require('jj').setup(${lib.generators.toLua { } cfg.settings})
          end
        '';
      }
    ];

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
                ${lib.optionalString config.plugins.lz-n.enable ''require("lz.n").trigger_load("jj.nvim")''}
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
  };
}
