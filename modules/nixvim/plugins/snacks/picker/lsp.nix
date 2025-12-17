{
  config,
  lib,
  ...
}:
{
  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
      [
        {
          mode = "n";
          key = "<leader>fd";
          action = "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>";
          options = {
            desc = "Find buffer diagnostics";
          };
        }
        {
          mode = "n";
          key = "<leader>fD";
          action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
          options = {
            desc = "Find workspace diagnostics";
          };
        }
        {
          mode = "n";
          key = "<leader>fl";
          action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
          options = {
            desc = "Find lsp document symbols";
          };
        }
        {
          mode = "n";
          key = "<leader>ld";
          action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
          options = {
            desc = "Goto Definition";
          };
        }
        {
          mode = "n";
          key = "<leader>li";
          action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
          options = {
            desc = "Goto Implementation";
          };
        }
        {
          mode = "n";
          key = "<leader>lD";
          action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
          options = {
            desc = "Find references";
          };
        }
        {
          mode = "n";
          key = "<leader>lt";
          action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
          options = {
            desc = "Goto Type Definition";
          };
        }

        {
          mode = "n";
          key = "gd";
          action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
          options = {
            desc = "Goto Definition";
          };
        }
        {
          mode = "n";
          key = "gD";
          action = "<cmd>lua Snacks.picker.lsp_declarations()<cr>";
          options = {
            desc = "Goto Declaration";
          };
        }
        {
          mode = "n";
          key = "grr";
          action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
          options = {
            desc = "Goto References";
            nowait = true;
          };
        }
        {
          mode = "n";
          key = "gri";
          action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
          options = {
            desc = "Goto Implementation";
          };
        }
        {
          mode = "n";
          key = "gy";
          action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
          options = {
            desc = "Goto T[y]pe Definition";
          };
        }
      ];
}
