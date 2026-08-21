{
  config,
  lib,
  ...
}:
{
  plugins = {
    minuet = {
      # minuet-ai.nvim documentation
      # See: https://github.com/milanglacier/minuet-ai.nvim
      enable = builtins.elem "minuet" config.khanelivim.ai.plugins;

      lazyLoad.settings.event = [ "InsertEnter" ];

      settings = {
        provider = "openai_fim_compatible";

        # One candidate keeps a local GPU responsive during insert mode.
        n_completions = 1;

        # A small window keeps request latency low. Raise it when the host
        # serves a larger model or has spare VRAM.
        context_window = 1024;

        provider_options.openai_fim_compatible = {
          # Ollama needs no credential, but minuet requires the name of a
          # non-null environment variable as a placeholder.
          api_key = "TERM";
          name = "Ollama";

          # The legacy completions endpoint carries the suffix field, so the
          # model receives the text on both sides of the cursor.
          end_point = "http://localhost:11434/v1/completions";

          # Only a base tag completes at the cursor. Its template splits the
          # text before the cursor from the text after it, which the instruct
          # tags do not do.
          model = "qwen2.5-coder:1.5b-base";

          optional = {
            max_tokens = 56;
            top_p = 0.9;
          };
        };
      };
    };
  };

  keymaps = lib.mkIf (builtins.elem "minuet" config.khanelivim.ai.plugins) [
    {
      mode = "n";
      key = "<leader>am";
      action = "<cmd>Minuet blink toggle<CR>";
      options = {
        desc = "Toggle Minuet Auto Completion";
      };
    }
  ];
}
