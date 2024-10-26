{
  plugins = {
    typescript-tools = {
      enable = true;
      settings = {
        separateDiagnosticServer = true;
        publishDiagnosticOn = "insert_leave";
        tsserverMaxMemory = "auto";
        tsserverLocale = "en";
        completeFunctionCalls = false;
        includeCompletionsWithInsertText = true;
        codeLens = "off";
        disableMemberCodeLens = true;
        jsxCloseTag = {
          enable = false;
          filetypes = [
            "javascriptreact"
            "typescriptreact"
          ];
        };
      };
    };
  };
}
