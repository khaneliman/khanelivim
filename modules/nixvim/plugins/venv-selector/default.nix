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

            local map = function(mode, key, command, desc)
              vim.keymap.set(mode, key, function()
                if vim.fn.exists(":" .. command) == 2 then
                  vim.cmd(command)
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

            map("n", "<leader>zv", "VenvSelect", "Select Virtual Environment")
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
            -- Available if options.cached_venv_automatic_activation = false
            -- map("n", "<leader>zc", "VenvSelectCache", "Activate Cached Virtual Environment")
            -- Available if options.log_level = "DEBUG" or "TRACE"
            -- map("n", "<leader>zl", "VenvSelectLog", "Open Venv Selector Log")
          end

          apply_venv_selector_maps(args.buf)
        end
      '';
    }
  ];
}
