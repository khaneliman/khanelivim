{
  lsp.servers.typos_lsp = {
    enable = true;
    config = {
      init_options = {
        diagnosticSeverity = "Hint";
      };
      filetypes = [
        "markdown"
        "text"
        "gitcommit"
        "gitrebase"
        "mail"
      ];
    };
  };
}
