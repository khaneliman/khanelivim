{
  plugins = {
    lsp = {
      servers = {
        harper_ls = {
          enable = true;
          settings = {
            "harper-ls" = {
              # Defaults https://github.com/Automattic/harper/blob/7bdc753b54cec79702807fb81a8defafc4a3f1be/harper-core/src/linting/lint_group.rs#L152C1-L187C3
              linters = {
                boring_words = true;
                linking_verbs = true;
                # Rarely useful with coding
                sentence_capitalization = false;
                spell_check = false;
              };
              codeActions = {
                forceStable = true;
              };
            };
          };
        };
      };
    };
  };
}
