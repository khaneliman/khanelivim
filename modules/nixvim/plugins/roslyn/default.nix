{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    roslyn = {
      enable = config.khanelivim.lsp.csharp == "roslyn";

      lazyLoad.settings.ft = [
        "cs"
        "razor"
      ];

      luaConfig.post = lib.mkIf config.plugins.rzls.enable ''
        vim.lsp.config("roslyn", {
              cmd = {
                  "Microsoft.CodeAnalysis.LanguageServer",
                  "--stdio",
                  "--logLevel=Information",
                  "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                  "--razorSourceGenerator=${pkgs.rzls}/lib/rzls/Microsoft.CodeAnalysis.Razor.Compiler.dll",
                  "--razorDesignTimePath=${pkgs.rzls}/lib/rzls/Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets"
              },
              handlers = require("rzls.roslyn_handlers"),
              settings = {
                  ["csharp|inlay_hints"] = {
                      csharp_enable_inlay_hints_for_implicit_object_creation = true,
                      csharp_enable_inlay_hints_for_implicit_variable_types = true,

                      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                      csharp_enable_inlay_hints_for_types = true,
                      dotnet_enable_inlay_hints_for_indexer_parameters = true,
                      dotnet_enable_inlay_hints_for_literal_parameters = true,
                      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                      dotnet_enable_inlay_hints_for_other_parameters = true,
                      dotnet_enable_inlay_hints_for_parameters = true,
                      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                  },
                  ["csharp|code_lens"] = {
                      dotnet_enable_references_code_lens = true,
                  },
              },
          })
          vim.lsp.enable("roslyn")
      '';

      settings = {
      };
    };
  };

  # TODO: https://github.com/dotnet/roslyn/issues/79939
  # Roslyn doesn't follow lsp spec and noice expects it to
  # Just disable progress for now
  autoCmd = lib.mkIf (config.khanelivim.lsp.csharp == "roslyn") [
    {
      event = [ "FileType" ];
      pattern = [ "cs" ];
      callback = {
        __raw = ''
          function()
            vim.api.nvim_clear_autocmds {
              group = "noice_lsp_progress",
              event = "LspProgress",
              pattern = "*",
            }
          end
        '';
      };
    }
  ];
}
