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

            map("n", "<leader>zv", "VenvSelect", "Select Virtual Environment")
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
