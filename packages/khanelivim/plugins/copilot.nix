{
  plugins = {
    copilot-lua = {
      enable = true;
      panel.enabled = false;
      suggestion.enabled = false;
    };

    copilot-chat = {
      enable = true;

      settings = {
        window = {
          layout = "float";
          relative = "cursor";
          width = 1;
          height = 0.5;
          row = 1;
        };
      };
    };
  };
}
