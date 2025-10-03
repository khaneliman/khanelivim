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
    plugins.sidekick.package = pkgs.vimPlugins.sidekick-nvim.overrideAttrs {
      version = "2025-10-03";
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "sidekick.nvim";
        rev = "c307316f77d80fbe92bd571c59ce1868703fe411";
        sha256 = "sha256-wVEEyiifTzGlAKlmFEQx0MAM+7Rsm0DAiXXPcnihMp8=";
      };
    };

    plugins.which-key.settings.spec = lib.optionals config.plugins.sidekick.enable [
      {
        __unkeyed-1 = "<leader>as";
        group = "Sidekick";
        icon = "🤖";
      }
    ];

    extraPackages = [
      pkgs.github-copilot-cli
    ];

    extraPlugins = [
      config.plugins.sidekick.package
    ];

    extraConfigLua = ''
      require('sidekick').setup(${lib.generators.toLua { } config.plugins.sidekick.settings})
    '';

    # TODO: Optional: Add keymaps for the plugin
    keymaps =
      (lib.optionals (!config.plugins.blink-cmp.enable) [
        {
          mode = [
            "n"
            "i"
          ];
          key = "<Tab>";
          action.__raw = ''
            function()
              -- if there is a next edit, jump to it, otherwise apply it if any
              if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>" -- fallback to normal tab
              end
            end
          '';
          options = {
            expr = true;
            desc = "Goto/Apply Next Edit Suggestion";
          };
        }
      ])
      ++ (lib.optionals config.plugins.blink-cmp.enable [
        {
          mode = "n";
          key = "<Tab>";
          action.__raw = ''
            function()
              -- if there is a next edit, jump to it, otherwise apply it if any
              if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>" -- fallback to normal tab
              end
            end
          '';
          options = {
            expr = true;
            desc = "Goto/Apply Next Edit Suggestion";
          };
        }
      ])
      ++ [
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
