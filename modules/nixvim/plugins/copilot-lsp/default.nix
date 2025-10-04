{
  plugins = {
    copilot-lsp = {
      # enable = config.khanelivim.ai.provider == "copilot";
      enable = true;

      settings = {
        nes = {
          move_count_threshold = 3;
        };
      };
    };
  };
}
