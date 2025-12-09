{
  config,
  ...
}:
{
  plugins = {
    copilot-lsp = {
      enable = builtins.elem "copilot-lsp" config.khanelivim.ai.plugins;

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
