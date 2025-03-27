{
  plugins.easy-dotnet = {
    enable = true;

    lazyLoad.settings.ft = [
      "cs"
      "fsharp"
      "xml"
    ];

    # TODO: https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file#nvim-dap-configuration
    settings = {
      picker = "fzf";
    };
  };
}
