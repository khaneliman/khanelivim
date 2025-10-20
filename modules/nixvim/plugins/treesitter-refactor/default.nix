{
  config,
  ...
}:
{
  plugins = {
    treesitter-refactor = {
      inherit (config.plugins.treesitter) enable;

      settings = {

        highlight_definitions = {
          enable = true;
          clearOnCursorMove = true;
        };
        smart_rename = {
          enable = true;
          keymaps = {
            # NOTE: default is "grr"
            # Changed from grR to gR to avoid conflict with gr (References)
            smart_rename = "gR";
          };
        };
        navigation = {
          enable = true;
        };
      };
    };
  };
}
