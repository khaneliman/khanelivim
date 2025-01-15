{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = self.lib.khanelivim.readAllFiles ./lsp;

  # TODO: migrate to mkneovimplugin
  extraConfigLuaPre = ''
    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }
  '';

  plugins = {
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-lines.enable = config.plugins.lsp.enable;
    lsp-signature.enable = config.plugins.lsp.enable;

    lsp = {
      enable = true;
      inlayHints = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>l[" = "goto_prev";
          "<leader>l]" = "goto_next";
          "<leader>lH" = "open_float";
        };

        extra =
          [
            {
              action.__raw = ''vim.lsp.buf.format'';
              mode = "v";
              key = "<leader>lf";
              options = {
                silent = true;
                buffer = false;
                desc = "Format selection";
              };
            }
          ]
          ++ lib.optionals (!config.plugins.glance.enable) [
            {
              action = "<CMD>PeekDefinition textDocument/definition<CR>";
              mode = "n";
              key = "<leader>lp";
              options = {
                desc = "Preview definition";
              };
            }
            {
              action = "<CMD>PeekDefinition textDocument/typeDefinition<CR>";
              mode = "n";
              key = "<leader>lP";
              options = {
                desc = "Preview type definition";
              };
            }
          ];

        lspBuf =
          {
            "<leader>lf" = "format";
            "<leader>lh" = "hover";
            "<leader>lr" = "rename";
          }
          // lib.optionalAttrs (!config.plugins.fzf-lua.enable) { "<leader>la" = "code_action"; }
          // lib.optionalAttrs (!config.plugins.fzf-lua.enable) {
            "<leader>ld" = "definition";
            "<leader>li" = "implementation";
            "<leader>lD" = "references";
            "<leader>lt" = "type_definition";
          };
      };

      servers = {
        bashls.enable = true;
        biome.enable = true;
        cmake.enable = true;
        csharp_ls.enable = true;
        cssls.enable = true;
        dockerls.enable = true;
        eslint.enable = true;
        fish_lsp.enable = true;
        fsautocomplete.enable = true;

        fsharp_language_server = {
          enable = false;
          # TODO: package FSharpLanguageServer
          # cmd = [ "${pkgs.fsharp-language-server}/FSharpLanguageServer.dll" ];
        };

        gdscript = {
          enable = true;
          package = pkgs.gdtoolkit_4;
        };

        html.enable = true;
        java_language_server.enable = !config.plugins.nvim-jdtls.enable;
        jdtls.enable = !config.plugins.nvim-jdtls.enable;
        jsonls.enable = true;
        lua_ls.enable = true;
        marksman.enable = true;
        nushell.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        sqls.enable = true;
        statix.enable = true;
        stylelint_lsp.enable = true;
        tailwindcss.enable = true;
        taplo.enable = true;
        ts_ls.enable = !config.plugins.typescript-tools.enable;
        yamlls.enable = true;
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>l";
        group = "LSP";
        icon = " ";
      }
      {
        __unkeyed-1 = "<leader>la";
        desc = "Code Action";
      }
      {
        __unkeyed-1 = "<leader>ld";
        desc = "Definition";
      }
      {
        __unkeyed-1 = "<leader>lD";
        desc = "References";
      }
      {
        __unkeyed-1 = "<leader>lf";
        desc = "Format";
      }
      {
        __unkeyed-1 = "<leader>l[";
        desc = "Prev";
      }
      {
        __unkeyed-1 = "<leader>l]";
        desc = "Next";
      }
      {
        __unkeyed-1 = "<leader>lt";
        desc = "Type Definition";
      }
      {
        __unkeyed-1 = "<leader>li";
        desc = "Implementation";
      }
      {
        __unkeyed-1 = "<leader>lh";
        desc = "Lsp Hover";
      }
      {
        __unkeyed-1 = "<leader>lH";
        desc = "Diagnostic Hover";
      }
      {
        __unkeyed-1 = "<leader>lr";
        desc = "Rename";
      }
    ];
  };
}
