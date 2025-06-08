{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Upstream module
  options.plugins.patterns = {
    enable = lib.mkEnableOption "patterns" // {
      default = true;
    };

    # Dummy options with regex patterns for testing plugin functionality
    sampleSsnPattern = lib.mkOption {
      type = lib.types.str;
      default = "d{3}-d{2}-d{4}";
      description = "Sample SSN pattern (123-45-6789)";
    };

    sampleEmailPattern = lib.mkOption {
      type = lib.types.str;
      default = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}";
      description = "Sample email pattern";
    };

    sampleUrlPattern = lib.mkOption {
      type = lib.types.str;
      default = "^(https?://)([da-z.-]+).([a-z.]{2,6})([/w .-]*)*/?$";
      description = "Sample URL pattern";
    };
  };

  config = lib.mkIf config.plugins.patterns.enable {
    extraPlugins = [
      pkgs.vimPlugins.patterns-nvim
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>ph";
        action = "<cmd>Patterns hover<CR>";
        options = {
          desc = "Patterns hover";
        };
      }
      {
        mode = "n";
        key = "<leader>pe";
        action = "<cmd>Patterns explain<CR>";
        options = {
          desc = "Patterns explain";
        };
      }
    ];
  };
}
