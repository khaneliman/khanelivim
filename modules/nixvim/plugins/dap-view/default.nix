{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-view = {
      # dap-view.nvim documentation
      # See: https://github.com/igorlfs/nvim-dap-view
      enable = config.khanelivim.debugging.ui == "dap-view";

      settings = {
        auto_toggle = true;
        follow_tab = true;
        switchbuf = "usetab,newtab";
        virtual_text = {
          enabled = !config.plugins.dap-virtual-text.enable;
        };
        windows = {
          position = "below";
          size = 0.35;
        };
        winbar = {
          default_section = "scopes";
          sections = [
            "watches"
            "scopes"
            "exceptions"
            "repl"
            "sessions"
            "breakpoints"
            "threads"
            "console"
          ];
          controls = {
            enabled = true;
          };
        };
        render = {
          threads = {
            format.__raw = ''
              function(name, lnum, path)
                return {
                  { text = name, separator = " " },
                  { text = vim.fn.fnamemodify(path, ":t"), hl = "FileName", separator = ":" },
                  { text = lnum, hl = "LineNumber" },
                }
              end
            '';
          };
          breakpoints = {
            format.__raw = ''
              function(line, lnum, path)
                return {
                  { text = vim.fn.fnamemodify(path, ":t"), hl = "FileName", separator = ":" },
                  { text = lnum, hl = "LineNumber", separator = " " },
                  { text = vim.trim(line), hl = "Normal" },
                }
              end
            '';
            align = true;
          };
        };
      };
    };
  };

  keymaps = lib.optionals (config.khanelivim.debugging.ui == "dap-view") [
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = ''
        function()
          require('dap.ext.vscode').load_launchjs(nil, {})
          require("dap-view").toggle()
        end
      '';
      options = {
        desc = "Toggle Debugger UI";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dw";
      action = "<CMD>DapViewWatch<CR>";
      options = {
        desc = "Add Watch";
      };
    }
    {
      mode = "n";
      key = "<leader>dv";
      action = "<CMD>DapViewVirtualTextToggle<CR>";
      options = {
        desc = "Toggle Virtual Text";
      };
    }
  ];
}
