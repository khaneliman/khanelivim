{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    conform-nvim = {
      # conform-nvim documentation
      # See: https://github.com/stevearc/conform.nvim
      enable = true;

      autoInstall = {
        enable = true;
        overrides = {
          swift_format = lib.mkIf pkgs.stdenv.hostPlatform.isLinux null;
        };
      };

      lazyLoad.settings = {
        cmd = [
          "ConformInfo"
        ];
        event = [ "BufWritePre" ];
      };

      luaConfig.pre = ''
        local slow_format_filetypes = {}
        local web_tools = require("khanelivim.web_tools")
      '';
      luaConfig.post = ''
        local conform = require("conform")
        local function dynamic_web_formatters(filetype)
          return function(bufnr)
            local preferred = web_tools.preferred_formatters(bufnr, filetype)
            return preferred and preferred.formatters or nil
          end
        end

        conform.formatters_by_ft.javascript = dynamic_web_formatters("javascript")
        conform.formatters_by_ft.javascriptreact = dynamic_web_formatters("javascriptreact")
        conform.formatters_by_ft.typescript = dynamic_web_formatters("typescript")
        conform.formatters_by_ft.typescriptreact = dynamic_web_formatters("typescriptreact")
        conform.formatters_by_ft.html = dynamic_web_formatters("html")
        conform.formatters_by_ft.css = dynamic_web_formatters("css")
        conform.formatters_by_ft.scss = dynamic_web_formatters("scss")
        conform.formatters_by_ft.sass = dynamic_web_formatters("sass")
      '';

      settings = {
        default_format_opts = {
          lsp_format = "fallback";
        };

        format_on_save = /* Lua */ ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

             -- Disable autoformat for slow filetypes
            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

             -- Disable autoformat for files in a certain path
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") or bufname:match("/.direnv/") then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 500, lsp_format = "fallback" }, on_format
           end
        '';

        format_after_save = /* Lua */ ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_format = "fallback" }
          end
        '';

        # NOTE:
        # Conform will run multiple formatters sequentially
        # [ "1" "2" "3"]
        # Add stop_after_first to run only the first available formatter
        # { "__unkeyed-1" = "foo"; "__unkeyed-2" = "bar"; stop_after_first = true; }
        # Use the "*" filetype to run formatters on all filetypes.
        # Use the "_" filetype to run formatters on filetypes that don't
        # have other formatters configured.
        formatters_by_ft = {
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          bicep = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ "bicep" ];
          c = [ "clang_format" ];
          cmake = [ "cmake-format" ];
          cpp = [ "clang_format" ];
          cs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ "csharpier" ];
          css = [ "stylelint" ];
          scss = [ "stylelint" ];
          sass = [ "stylelint" ];
          fish = [ "fish_indent" ];
          fsharp = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ "fantomas" ];
          gdscript = [ "gdformat" ];
          go = [ "golines" ];
          java = [ "google-java-format" ];
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "biome";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "biome";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          json = [ "jq" ];
          html = [ "prettierd" ];
          http = [ "kulala-fmt" ];
          kdl = [ "kdlfmt" ];
          lua = [ "stylua" ];
          markdown = [ "deno_fmt" ];
          nix = [ "nixfmt" ];
          python = [
            "ruff_fix"
            "ruff_format"
            "ruff_organize_imports"
          ];
          rest = [ "kulala-fmt" ];
          rust = [ "rustfmt" ];
          sh = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          sql = [ "sqlfluff" ];
          swift = [ "swift_format" ];
          terraform = [ "terraform_fmt" ];
          toml = [ "taplo" ];
          typescript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "biome";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "biome";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          xml = [
            "xmlformat"
            "xmllint"
          ];
          yaml = [ "yamlfmt" ];
          zig = [ "zigfmt" ];
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
        };

        formatters = {
          biome = {
            env = {
              BIOME_CONFIG_PATH = pkgs.writeTextFile {
                name = "biome.json";
                text = lib.generators.toJSON { } {
                  "$schema" = "${pkgs.biome}/node_modules/@biomejs/biome/configuration_schema.json";
                  formatter.useEditorconfig = true;
                };
              };
            };
          };
          csharpier = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
            command = lib.getExe pkgs.csharpier;
          };
        };
      };
    };
  };

  keymaps = lib.optionals config.plugins.conform-nvim.enable [
    {
      action.__raw = ''
        function(args)
         vim.cmd({cmd = 'Conform', args = args});
        end
      '';
      mode = "v";
      key = "<leader>lf";
      options = {
        silent = true;
        buffer = false;
        desc = "Format selection";
      };
    }
    {
      action.__raw = ''
        function()
          vim.cmd('Conform');
        end
      '';
      key = "<leader>lf";
      options = {
        silent = true;
        desc = "Format buffer";
      };
    }
  ];

  userCommands = lib.mkIf config.plugins.conform-nvim.enable {
    Conform = {
      desc = "Formatting using conform.nvim";
      range = true;
      command.__raw = ''
        function(args)
          ${lib.optionalString config.plugins.lz-n.enable "require('lz.n').trigger_load('conform.nvim')"}
          local range = nil
          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
              start = { args.line1, 0 },
              ["end"] = { args.line2, end_line:len() },
            }
          end
          require("conform").format({ async = true, lsp_format = "fallback", range = range },
          function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end
      '';
    };
    WebToolingInfo = {
      desc = "Show detected web tooling for the current workspace";
      command.__raw = ''
        function()
          local details = require("khanelivim.web_tools").describe(0)
          local preferred = details.preferred
          local lines = {
            "Filetype: " .. details.filetype,
            "Biome: " .. (details.detected.biome or "none"),
            "ESLint: " .. (details.detected.eslint or "none"),
            "Prettier: " .. (details.detected.prettier or "none"),
          }

          if preferred then
            table.insert(lines, "Formatter owner: " .. preferred.owner)
            table.insert(lines, "Formatters: " .. table.concat(vim.tbl_filter(function(item)
              return type(item) == "string"
            end, preferred.formatters), ", "))
          else
            table.insert(lines, "Formatter owner: none")
          end

          vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Web Tooling" })
        end
      '';
    };
  };
}
