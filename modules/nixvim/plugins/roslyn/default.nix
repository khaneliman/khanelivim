{
  config,
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
}
