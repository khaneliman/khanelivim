{
  config,
  lib,
  ...
}:
{
  plugins = {
    roslyn = {
      enable = config.khanelivim.lsp.csharp == "roslyn";

      lazyLoad.settings.ft = [
        "cs"
        "fsharp"
        "xml"
      ];

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
