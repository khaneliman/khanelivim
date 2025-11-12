{
  config,
  lib,
  ...
}:
{
  plugins = {
    devdocs = {
      enable = lib.elem "devdocs" config.khanelivim.documentation.viewers;

      lazyLoad.settings.cmd = [
        "DevDocs"
      ];
    };

    which-key.settings.spec = lib.mkIf config.plugins.devdocs.enable [
      {
        __unkeyed-1 = "<leader>D";
        group = "DevDocs";
        icon = " ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.devdocs.enable [
    {
      mode = "n";
      key = "<leader>Dd";
      action = "<CMD>DevDocs delete<CR>";
      options = {
        desc = "Delete DevDoc";
      };
    }
    {
      mode = "n";
      key = "<leader>Df";
      action.__raw = ''
        function()
          local devdocs = require("devdocs")
          local installedDocs = devdocs.GetInstalledDocs()
          vim.ui.select(installedDocs, {}, function(selected)
            if not selected then
              return
            end
            local docDir = devdocs.GetDocDir(selected)
            -- prettify the filename as you wish
            Snacks.picker.files({ cwd = docDir })
          end)
        end
      '';
      options = {
        desc = "Find DevDocs";
      };
    }
    {
      mode = "n";
      key = "<leader>Dg";
      action = "<CMD>DevDocs get<CR>";
      options = {
        desc = "Get DevDocs";
      };
    }
    {
      mode = "n";
      key = "<leader>Di";
      action = "<CMD>DevDocs install<CR>";
      options = {
        desc = "Install DevDocs";
      };
    }
  ];
}
