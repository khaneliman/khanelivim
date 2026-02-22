{
  config,
  ...
}:
{
  plugins.copilot-lsp = {
    # copilot-lsp.nvim documentation
    # See: https://github.com/copilotlsp-nvim/copilot-lsp
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
}
