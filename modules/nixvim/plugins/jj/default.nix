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
      default = true;
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
      description = "Configuration for jj";
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua = ''
      require('jj').setup(${lib.generators.toLua { } cfg.settings})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>jd";
        action.__raw = "require('jj.cmd').describe";
        options = {
          desc = "Describe";
        };
      }
      {
        mode = "n";
        key = "<leader>jl";
        action.__raw = "require('jj.cmd').log";
        options = {
          desc = "Log";
        };
      }
      {
        mode = "n";
        key = "<leader>je";
        action.__raw = "require('jj.cmd').edit";
        options = {
          desc = "Edit";
        };
      }
      {
        mode = "n";
        key = "<leader>jn";
        action.__raw = "require('jj.cmd').new";
        options = {
          desc = "New";
        };
      }
      {
        mode = "n";
        key = "<leader>js";
        action.__raw = "require('jj.cmd').status";
        options = {
          desc = "Status";
        };
      }
      {
        mode = "n";
        key = "<leader>jS";
        action.__raw = "require('jj.cmd').squash";
        options = {
          desc = "Squash";
        };
      }
      {
        mode = "n";
        key = "<leader>ju";
        action.__raw = "require('jj.cmd').undo";
        options = {
          desc = "Undo";
        };
      }
      {
        mode = "n";
        key = "<leader>jy";
        action.__raw = "require('jj.cmd').redo";
        options = {
          desc = "Redo";
        };
      }
      {
        mode = "n";
        key = "<leader>jr";
        action.__raw = "require('jj.cmd').rebase";
        options = {
          desc = "Rebase";
        };
      }
      {
        mode = "n";
        key = "<leader>jbc";
        action.__raw = "require('jj.cmd').bookmark_create";
        options = {
          desc = "Create bookmark";
        };
      }
      {
        mode = "n";
        key = "<leader>jbd";
        action.__raw = "require('jj.cmd').bookmark_delete";
        options = {
          desc = "Delete bookmark";
        };
      }
      {
        mode = "n";
        key = "<leader>jbm";
        action.__raw = "require('jj.cmd').bookmark_move";
        options = {
          desc = "Move bookmark";
        };
      }
      {
        mode = "n";
        key = "<leader>ja";
        action.__raw = "require('jj.cmd').abandon";
        options = {
          desc = "Abandon";
        };
      }
      {
        mode = "n";
        key = "<leader>jf";
        action.__raw = "require('jj.cmd').fetch";
        options = {
          desc = "Fetch";
        };
      }
      {
        mode = "n";
        key = "<leader>jp";
        action.__raw = "require('jj.cmd').push";
        options = {
          desc = "Push";
        };
      }
      {
        mode = "n";
        key = "<leader>jpr";
        action.__raw = "require('jj.cmd').open_pr";
        options = {
          desc = "Open PR";
        };
      }
      {
        mode = "n";
        key = "<leader>jpl";
        action.__raw = ''
          function()
              require("jj.cmd").open_pr { list_bookmarks = true }
          end
        '';
        options = {
          desc = "Open PR (List)";
        };
      }
      # Diff commands
      {
        mode = "n";
        key = "<leader>gdf";
        action.__raw = ''
          function() require("jj.diff").open_diff() end
        '';
        options = {
          desc = "Diff current buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>gdF";
        action.__raw = ''
          function() require("jj.diff").open_hsplit() end
        '';
        options = {
          desc = "Diff current buffer (Split)";
        };
      }
      # Pickers
      {
        mode = "n";
        key = "<leader>gj";
        action.__raw = ''
          function() require("jj.picker").status() end
        '';
        options = {
          desc = "Status picker";
        };
      }
      {
        mode = "n";
        key = "<leader>jh";
        action.__raw = ''
          function() require("jj.picker").file_history() end
        '';
        options = {
          desc = "History picker";
        };
      }
      # Log all
      {
        mode = "n";
        key = "<leader>jL";
        action.__raw = ''
          function()
            require("jj.cmd").log {
              revisions = "all()",
            }
          end
        '';
        options = {
          desc = "Log all";
        };
      }
      # Tug
      {
        mode = "n";
        key = "<leader>jt";
        action.__raw = ''
          function()
            require("jj.cmd").j("tug")
            require("jj.cmd").log({})
          end
        '';
        options = {
          desc = "Tug";
        };
      }
    ];
  };
}
