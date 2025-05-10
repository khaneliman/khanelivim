{
  config,
  lib,
  ...
}:
{
  plugins = {
    avante = {
      enable = true;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        # Define our own mappings under correct prefix
        mappings = {
          ask = "<leader>aaa";
          edit = "<leader>aae";
          refresh = "<leader>aar";
          focus = "<leader>aaf";
          stop = "<leader>aaS";
          toggle = {
            default = "<leader>aat";
            debug = "<leader>aad";
            hint = "<leader>aah";
            suggestion = "<leader>aas";
            repomap = "<leader>aaR";
          };
          files = {
            add_current = "<leader>aa.";
            add_all_buffers = "<leader>aaB";
          };
          select_model = "<leader>aa?";
          select_history = "<leader>aah";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>aa";
        group = "Avante";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.avante.enable [
    {
      mode = "n";
      key = "<leader>aac";
      action = "<CMD>AvanteClear<CR>";
      options.desc = "avante: clear";
    }
  ];
}
