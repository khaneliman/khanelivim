{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.mkIf config.plugins.venv-selector.enable (
    with pkgs;
    [
      fd
    ]
  );

  plugins.venv-selector = {
    # venv-selector.nvim documentation
    # See: https://github.com/linux-cultist/venv-selector.nvim
    enable = true;

    lazyLoad.settings.ft = [ "python" ];

    settings = {
      options = {
        picker =
          if config.plugins.snacks.enable then
            "snacks"
          else if config.plugins.fzf-lua.enable then
            "fzf-lua"
          else
            "auto";
        override_notify = false;
        require_lsp_activation = true;
      };
    };
  };

  autoGroups = lib.mkIf config.plugins.venv-selector.enable {
    venv_selector_group = { };
  };

  autoCmd = lib.mkIf config.plugins.venv-selector.enable [
    {
      event = "FileType";
      pattern = [ "python" ];
      group = "venv_selector_group";
      callback.__raw = ''
        function(args)
          local function apply_venv_selector_maps(bufnr)
            local opts = function(desc)
              return { buffer = bufnr, desc = desc }
            end

            local function has_workspace_hint(bufnr)
              local path = vim.api.nvim_buf_get_name(bufnr)
              if path == "" then
                return false
              end

              local venv_dirs = vim.fs.find({ ".venv", "venv" }, {
                path = path,
                type = "directory",
                limit = 1,
                upward = true,
              })
              if #venv_dirs > 0 then
                return true
              end

              local manager_files = vim.fs.find({
                "environment.yml",
                "environment.yaml",
                "Pipfile",
                "pixi.toml",
                "poetry.lock",
                "pyproject.toml",
                "requirements.txt",
              }, {
                path = path,
                type = "file",
                limit = 1,
                upward = true,
              })

              return #manager_files > 0
            end

            local map = function(mode, key, command, desc, on_missing)
              vim.keymap.set(mode, key, function()
                if vim.fn.exists(":" .. command) == 2 then
                  vim.cmd(command)
                  return
                end
                if on_missing then
                  on_missing()
                  return
                end
                vim.notify(command .. " is not ready yet", vim.log.levels.WARN)
              end, opts(desc))
            end

            local with_neotest = function(desc, fn)
              return function()
                ${lib.optionalString config.plugins.lz-n.enable "pcall(function() require('lz.n').trigger_load('neotest') end)"}
                local ok, neotest = pcall(require, "neotest")
                if not ok then
                  vim.notify(desc .. " requires neotest", vim.log.levels.WARN)
                  return
                end
                fn(neotest)
              end
            end

            vim.keymap.set("n", "<leader>zv", function()
              if not has_workspace_hint(bufnr) then
                vim.notify(
                  "No obvious local virtual environment markers were found. VenvSelect only lists existing environments; create one with `python -m venv .venv` or `uv venv` if none appear.",
                  vim.log.levels.INFO
                )
              end

              if vim.fn.exists(":VenvSelect") == 2 then
                vim.cmd("VenvSelect")
                return
              end

              vim.notify("VenvSelect is not ready yet", vim.log.levels.WARN)
            end, opts("Select Virtual Environment"))
            map(
              "n",
              "<leader>zc",
              "VenvSelectCached",
              "Activate Cached Virtual Environment",
              function()
                vim.notify(
                  "Cached virtual environments are activating automatically. Set `cached_venv_automatic_activation = false` to use :VenvSelectCached manually.",
                  vim.log.levels.INFO
                )
              end
            )
            vim.keymap.set(
              "n",
              "<leader>zt",
              with_neotest("Run nearest Python test", function(neotest)
                neotest.run.run()
              end),
              opts("Run Nearest Python Test")
            )
            vim.keymap.set(
              "n",
              "<leader>zT",
              with_neotest("Run Python test file", function(neotest)
                neotest.run.run(vim.fn.expand("%"))
              end),
              opts("Run Python Test File")
            )
            vim.keymap.set(
              "n",
              "<leader>zl",
              with_neotest("Run last Python test", function(neotest)
                neotest.run.run_last()
              end),
              opts("Run Last Python Test")
            )
            ${lib.optionalString config.plugins.dap.enable ''
              vim.keymap.set(
                "n",
                "<leader>zd",
                with_neotest("Debug nearest Python test", function(neotest)
                  neotest.run.run({ strategy = "dap" })
                end),
                opts("Debug Nearest Python Test")
              )
            ''}
            map(
              "n",
              "<leader>zL",
              "VenvSelectLog",
              "Open Venv Selector Log",
              function()
                vim.notify(
                  "Enable `plugins.venv-selector.settings.options.debug = true` to use :VenvSelectLog.",
                  vim.log.levels.INFO
                )
              end
            )
          end

          apply_venv_selector_maps(args.buf)
        end
      '';
    }
  ];
}
