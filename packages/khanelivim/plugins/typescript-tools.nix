{
  plugins = {
    typescript-tools = {
      enable = true;
      settings = {
        settings = {
          separate_diagnostic_server = true;
          publish_diagnostic_on = "insert_leave";
          tsserver_max_memory = "auto";
          tsserver_locale = "en";
          complete_function_calls = false;
          include_completions_with_insert_text = true;
          code_lens = "off";
          disable_member_code_lens = true;
          jsx_close_tag = {
            enable = false;
            filetypes = [
              "javascriptreact"
              "typescriptreact"
            ];
          };
        };
      };
    };
  };
}
