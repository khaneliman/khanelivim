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
        provider = "claude-code";
        providers = {
          claude = {
            model = "claude-sonnet-4-5";
          };
        };
        acp_proivders = {
          claude-code = {
            model = "claude-sonnet-4-5";
            env = {
              ANTHROPIC_API_KEY.__raw = ''os.getenv("ANTHROPIC_API_KEY")'';
            };
          };
          gemini-cli = {
            model = "gemini-2.5-pro";
            env = {
              GEMINI_API_KEY.__raw = ''os.getenv("GEMINI_API_KEY")'';
            };
          };
        };
        # Define our own mappings under correct prefix
        mappings = {
          ask = "<leader>aaa";
          new_ask = "<leader>aan";
          edit = "<leader>aae";
          refresh = "<leader>aar";
          focus = "<leader>aaf";
          stop = "<leader>aaS";
          toggle = {
            default = "<leader>aat";
            debug = "<leader>aad";
            hint = "<leader>aah";
            selection = "<leader>aaC";
            suggestion = "<leader>aas";
            repomap = "<leader>aaR";
          };
          files = {
            add_current = "<leader>aa.";
            add_all_buffers = "<leader>aaB";
          };
          select_model = "<leader>aa?";
          select_history = "<leader>aah";
          zen_mode = "<leader>aaz";
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>aa";
        group = "Avante";
        icon = "";
        mode = [
          "n"
          "v"
        ];
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
