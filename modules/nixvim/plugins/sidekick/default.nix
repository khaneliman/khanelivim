{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.sidekick = {
    enable = lib.mkEnableOption "sidekick" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "sidekick" {
      default = "sidekick-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        mux = {
          enabled = true;
        };
      };
      description = "Configuration for sidekick";
    };
  };

  config = lib.mkIf config.plugins.sidekick.enable {
    plugins.which-key.settings.spec = lib.optionals config.plugins.sidekick.enable [
      {
        __unkeyed-1 = "<leader>as";
        group = "Sidekick";
        icon = "🤖";
      }
    ];

    extraPlugins = [
      config.plugins.sidekick.package
    ];

    extraConfigLua = ''
      require('sidekick').setup(${lib.generators.toLua { } config.plugins.sidekick.settings})
    '';

    # TODO: Optional: Add keymaps for the plugin
    keymaps = [
      {
        mode = "n";
        key = "<leader>ast";
        action.__raw = "function() require('sidekick.cli').toggle({ focus = true }) end";
        options.desc = "Sidekick Toggle";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>asp";
        action.__raw = "function() require('sidekick.cli').select_prompt() end";
        options.desc = "Ask Prompt";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>asc";
        action.__raw = "function() require('sidekick.cli').toggle({ name = 'claude', focus = true }) end";
        options.desc = "Claude Toggle";
      }
      # TODO: get copilot-cli packaged
      # {
      #   mode = [
      #     "n"
      #     "v"
      #   ];
      #   key = "<leader>asC";
      #   action.__raw = "function() require('sidekick.cli').toggle({ name = 'copilot', focus = true }) end";
      #   options.desc = "Copilot Toggle";
      # }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>asg";
        action.__raw = "function() require('sidekick.cli').toggle({ name = 'gemini', focus = true }) end";
        options.desc = "Gemini Toggle";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>aso";
        action.__raw = "function() require('sidekick.cli').toggle({ name = 'opencode', focus = true }) end";
        options.desc = "Opencode Toggle";
      }
    ];
  };
}
