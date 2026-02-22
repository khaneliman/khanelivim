{
  # typos-lsp documentation
  # See: https://github.com/tekumara/typos-lsp
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
