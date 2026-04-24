{
  config,
  inputs,
  lib,
  system,
  ...
}:
let
  cfg = config.plugins.rustowl;
  luaConfig = ''
    require('rustowl').setup(${lib.nixvim.toLuaObject cfg.settings})
  '';
in
{
  options.plugins.rustowl = {
    enable = lib.mkEnableOption "rustowl" // {
      default = config.khanelivim.lsp.rust != null;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.rustowl-flake.packages.${system}.rustowl-nvim;
      defaultText = lib.literalExpression "inputs.rustowl-flake.packages.\${system}.rustowl-nvim";
      description = "The RustOwl Neovim plugin package to use.";
    };

    serverPackage = lib.mkOption {
      type = lib.types.package;
      default = inputs.rustowl-flake.packages.${system}.rustowl;
      defaultText = lib.literalExpression "inputs.rustowl-flake.packages.\${system}.rustowl";
      description = "The RustOwl server package to expose in Neovim's PATH.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        auto_enable = true;
        client = {
          root_dir.__raw = ''
            function()
              return vim.fs.root(0, { "Cargo.toml" })
            end
          '';
          on_attach.__raw = ''
            function(_, buffer)
              local function rustowl_notify(message, level)
                vim.notify(message, level or vim.log.levels.INFO, { title = "RustOwl" })
              end

              local function map(key, action, desc)
                vim.keymap.set("n", key, function()
                  local rustowl = require("rustowl")
                  rustowl[action](buffer)
                  rustowl_notify("RustOwl " .. action:gsub("_", " "))
                end, { buffer = buffer, desc = desc })
              end

              map("<leader>zv", "enable", "Enable RustOwl")
              map("<leader>zV", "disable", "Disable RustOwl")

              vim.keymap.set("n", "<leader>zR", function()
                vim.cmd("Rustowl restart_client")
                rustowl_notify("RustOwl client restarted")
              end, { buffer = buffer, desc = "Restart RustOwl Client" })
            end
          '';
        };
        highlight_style = "underline";
        idle_time = 300;
      };
      description = ''
        Configuration passed to `require('rustowl').setup(...)`.

        See <https://github.com/cordx56/rustowl/blob/master/docs/neovim-configuration.md>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    extraPackages = [ cfg.serverPackage ];

    extraConfigLua = luaConfig;

    extraPlugins = [ cfg.package ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>zw";
        action.__raw = ''
          function()
            local rustowl = require("rustowl")
            rustowl.toggle()

            local enabled = rustowl.is_enabled()
            vim.notify(
              "RustOwl " .. (enabled and "enabled" or "disabled"),
              vim.log.levels.INFO,
              { title = "RustOwl" }
            )
          end
        '';
        options = {
          desc = "Toggle RustOwl";
        };
      }
    ];
  };
}
