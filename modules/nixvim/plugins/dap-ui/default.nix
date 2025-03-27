{
  config,
  lib,
  ...
}:
{
  plugins = {
    dap-ui = {
      enable = true;

      # lazyLoad.settings = {
      #   before.__raw = ''
      #     function()
      #       require('lz.n').trigger_load('nvim-dap')
      #     end
      #   '';
      #   keys = [
      #     {
      #       __unkeyed-1 = "<leader>du";
      #       __unkeyed-2.__raw = ''
      #         function()
      #           require('dap.ext.vscode').load_launchjs(nil, {})
      #           require("dapui").toggle()
      #         end
      #       '';
      #       desc = "Toggle Debugger UI";
      #     }
      #   ];
      # };
    };

    which-key.settings.spec = lib.optionals config.plugins.dap.enable [
      {
        __unkeyed-1 = "<leader>d";
        mode = "n";
        desc = "Debug";
        # icon = " ";
      }
    ];
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
    (lib.mkIf (!config.plugins.lz-n.enable) {
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
