{ config, lib, ... }:
let
  typescriptToolsEnabled = config.khanelivim.lsp.typescript == "typescript-tools";
in
{
  plugins = {
    typescript-tools = {
      # typescript-tools.nvim documentation
      # See: https://github.com/pmizio/typescript-tools.nvim
      enable = typescriptToolsEnabled;

      lazyLoad.settings.ft = [
        "typescript"
        "javascript"
        "typescriptreact"
        "javascriptreact"
      ];

      settings = {
        settings = {
          code_lens = "off";
          complete_function_calls = false;
          disable_member_code_lens = true;
          expose_as_code_action = "all";
          include_completions_with_insert_text = true;
          publish_diagnostic_on = "insert_leave";
          separate_diagnostic_server = true;
          # Prefer project-local TypeScript and Yarn SDK resolution.
          tsserver_locale = "en";
          tsserver_max_memory = "auto";
          jsx_close_tag = {
            enable = false;
            filetypes = [
              "javascriptreact"
              "typescriptreact"
            ];
          };
        };
      };
    };
  };

  userCommands = lib.mkIf typescriptToolsEnabled {
    TSToolsOpenTsserverLog = {
      command.__raw = ''
        function()
          local log_dir = vim.uv.os_tmpdir()
          local syntax_log = vim.fs.joinpath(log_dir, "tsserver_syntax.log")
          local semantic_log = vim.fs.joinpath(log_dir, "tsserver_semantic.log")
          local syntax_exists = vim.fn.filereadable(syntax_log) == 1
          local semantic_exists = vim.fn.filereadable(semantic_log) == 1

          if syntax_exists and semantic_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(syntax_log)))
            vim.cmd(string.format("vsplit %s", vim.fn.fnameescape(semantic_log)))
            return
          end

          if syntax_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(syntax_log)))
            return
          end

          if semantic_exists then
            vim.cmd(string.format("tabnew %s", vim.fn.fnameescape(semantic_log)))
            return
          end

          vim.notify(
            "No tsserver logs found. Use the debug profile or enable plugins.typescript-tools.settings.settings.tsserver_logs.",
            vim.log.levels.WARN
          )
        end
      '';
      desc = "Open TypeScript tsserver logs.";
    };
  };
}
