{
  config,
  ...
}:
{
  plugins = {
    rzls = {
      enable = config.khanelivim.lsp.csharp == "roslyn";
      enableRazorFiletypeAssociation = true;

      lazyLoad.settings.ft = [
        "cs"
        "razor"
      ];
    };
  };
}
