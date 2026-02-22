{
  config,
  ...
}:
{
  plugins = {
    rzls = {
      # rzls.nvim documentation
      # See: https://github.com/tris203/rzls.nvim
      enable = config.khanelivim.lsp.csharp == "roslyn";
      enableRazorFiletypeAssociation = true;

      lazyLoad.settings.ft = [
        "cs"
        "razor"
      ];
    };
  };
}
