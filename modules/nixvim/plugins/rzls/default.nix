{
  config,
  pkgs,
  ...
}:
{
  plugins = {
    rzls = {
      # FIXME: dotnet broken nixpkgs darwin
      enable = config.khanelivim.lsp.csharp == "roslyn" && pkgs.stdenv.hostPlatform.isLinux;
      enableRazorFiletypeAssociation = true;

      lazyLoad.settings.ft = [
        "cs"
        "razor"
      ];
    };
  };
}
