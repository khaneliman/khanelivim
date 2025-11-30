{
  plugins = {
    copilot-lsp = {
      # enable = config.khanelivim.ai.provider == "copilot";
      enable = true;

      lazyLoad.settings = {
        event = [ "InsertEnter" ];
      };

      settings = {
        nes = {
          move_count_threshold = 3;
        };
      };
    };
  };
}
