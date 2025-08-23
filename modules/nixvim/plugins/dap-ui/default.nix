{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-ui = {
      enable = config.khanelivim.editor.debugUI == "dap-ui";

      lazyLoad.settings = {
        before.__raw = lib.mkIf config.plugins.lz-n.enable ''
          function()
            require('lz.n').trigger_load('nvim-dap', {})
            require('lz.n').trigger_load('nvim-dap-virtual-text', {})
          end
        '';
        keys = [
          {
            __unkeyed-1 = "<leader>du";
            __unkeyed-2.__raw = ''
              function()
                require('dap.ext.vscode').load_launchjs(nil, {})
                require("dapui").toggle()
              end
            '';
            desc = "Toggle Debugger UI";
          }
        ];
      };
    };

    dap.luaConfig.pre =
      lib.mkIf config.plugins.dap-ui.enable
        # Lua
        ''
          -- DEBUG LISTENERS
          require("dap").listeners.before.attach.dapui_config = function()
            require("dapui").open()
          end
          require("dap").listeners.before.launch.dapui_config = function()
            require("dapui").open()
          end
          require("dap").listeners.before.event_terminated.dapui_config = function()
            require("dapui").close()
          end
          require("dap").listeners.before.event_exited.dapui_config = function()
            require("dapui").close()
          end
        '';
  };

  keymaps = lib.optionals config.plugins.dap-ui.enable [
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = ''
        function() require("dapui").eval() end
      '';
      options = {
        desc = "Evaluate Input";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expr)
            if expr then require("dapui").eval(expr, { enter = true }) end
          end)
        end
      '';
      options = {
        desc = "Evaluate Input";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dh";
      action.__raw = ''
        function() require("dap.ui.widgets").hover() end
      '';
      options = {
        desc = "Hover";
        silent = true;
      };
    }
    (lib.mkIf (!config.plugins.dap-ui.lazyLoad.enable) {
      mode = "n";
      key = "<leader>du";
      action.__raw = ''
        function()
          require('dap.ext.vscode').load_launchjs(nil, {})
          require("dapui").toggle()
        end
      '';
      options = {
        desc = "Toggle Debugger UI";
        silent = true;
      };
    })
  ];
}
