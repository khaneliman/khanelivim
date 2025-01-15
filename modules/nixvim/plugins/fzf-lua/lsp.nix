{ lib, config, ... }:
{
  keymaps = lib.mkIf config.plugins.fzf-lua.enable [
    {
      mode = "n";
      key = "<leader>fd";
      action = ''<cmd>FzfLua diagnostics_document<CR>'';
      options = {
        desc = "Find buffer diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>fD";
      action = ''<cmd>FzfLua diagnostics_workspace<CR>'';
      options = {
        desc = "Find workspace diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = ''<cmd>FzfLua lsp_document_symbols<CR>'';
      options = {
        desc = "Find lsp document symbols";
      };
    }
    {
      mode = "n";
      key = "<leader>ld";
      action = ''<cmd>FzfLua lsp_definitions<CR>'';
      options = {
        desc = "Goto definition";
      };
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = ''<cmd>FzfLua lsp_references<CR>'';
      options = {
        desc = "Find References";
      };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = ''<cmd>FzfLua lsp_implementations<CR>'';
      options = {
        desc = "Find Implementations";
      };
    }
    {
      mode = "n";
      key = "<leader>lt";
      action = ''<cmd>FzfLua lsp_typedefs<CR>'';
      options = {
        desc = "Goto Type Definition";
      };
    }
    {
      mode = "n";
      key = "<leader>la";
      action = ''<cmd>FzfLua lsp_code_actions<CR>'';
      options = {
        desc = "Code Action";
      };
    }
  ];
}
