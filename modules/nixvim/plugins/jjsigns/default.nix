{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.jjsigns = {
    enable = lib.mkEnableOption "jjsigns" // {
      default = builtins.elem "jjsigns" config.khanelivim.jj.integrations;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vimUtils.buildVimPlugin {
        pname = "jjsigns.nvim";
        version = "2025-08-27";
        src = pkgs.fetchFromGitHub {
          owner = "evanphx";
          repo = "jjsigns.nvim";
          rev = "f5f5cefef0945cc00ba914584275f9cef8c2e792";
          hash = "sha256-nZu61pIkd85nISneMBy82ZZPB7Wj85Uy2LsOoWo99CE=";
        };
      };
      description = "jjsigns.nvim package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        enabled = true;
        attach.auto = true;
        signcolumn = true;
        numhl = false;
        linehl = false;
        base = "@-";
        update_debounce = 100;
      };
      description = ''
        Configuration for jjsigns.

        See <https://github.com/evanphx/jjsigns.nvim>
      '';
    };
  };

  config =
    let
      luaConfig = ''
        require('jjsigns').setup(${lib.generators.toLua { } config.plugins.jjsigns.settings})
      '';
      loadIfJjRepo = ''
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path == "" then
          return
        end

        local dir = vim.fn.fnamemodify(path, ":p:h")
        if vim.fn.finddir(".jj", dir .. ";") == "" then
          return
        end

        if vim.g.khanelivim_jjsigns_loaded then
          return
        end

        vim.g.khanelivim_jjsigns_loaded = true
        ${lib.optionalString config.plugins.lz-n.enable ''
          require("lz.n").trigger_load("jjsigns.nvim")
        ''}
        ${lib.optionalString (!config.plugins.lz-n.enable) luaConfig}
      '';
    in
    lib.mkIf config.plugins.jjsigns.enable {
      dependencies.jj.enable = lib.mkDefault true;

      extraPlugins = [
        {
          plugin = config.plugins.jjsigns.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "jjsigns.nvim";
              cmd = [ "JjSigns" ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };

      autoCmd = [
        {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
          callback.__raw = ''
            function(args)
              ${loadIfJjRepo}
            end
          '';
        }
      ];

      keymaps = [
        {
          mode = "n";
          key = "<leader>ugj";
          action = "<cmd>JjSigns toggle<CR>";
          options = {
            desc = "Toggle JjSigns";
          };
        }
        {
          mode = "n";
          key = "<leader>ugS";
          action = "<cmd>JjSigns toggle_signs<CR>";
          options = {
            desc = "Toggle JjSigns Column";
          };
        }
        {
          mode = "n";
          key = "<leader>ugN";
          action = "<cmd>JjSigns toggle_numhl<CR>";
          options = {
            desc = "Toggle JjSigns Number Highlight";
          };
        }
        {
          mode = "n";
          key = "<leader>ugL";
          action = "<cmd>JjSigns toggle_linehl<CR>";
          options = {
            desc = "Toggle JjSigns Line Highlight";
          };
        }
      ];
    };
}
