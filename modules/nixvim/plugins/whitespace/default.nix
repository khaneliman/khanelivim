{
  lib,
  config,
  pkgs,
  ...
}:
{
  plugins.whitespace = lib.mkIf (config.khanelivim.text.whitespace == "whitespace-nvim") {
    # enable = true;
    # package = pkgs.vimPlugins.whitespace-nvim.overrideAttrs {
    #   source = pkgs.fetchFromGitHub {
    #     owner = "johnfrankmorgan";
    #     repo = "whitespace.nvim";
    #     rev = "406cd69216dd7847b0cb38486603a8ed5c4f8c77";
    #     sha256 = "sha256-LSK8Im42z8mvS/WbDQfE+ytl0wUYYpRDvAbO83OqGa8=";
    #   };
    # };

    settings = {
      highlight = "DiffDelete";
      ignored_filetypes = [
        "Avante"
        "AvanteInput"
        "TelescopePrompt"
        "Trouble"
        "blink-cmp-documentation"
        "blink-cmp-menu"
        "blink-cmp-signature"
        "checkhealth"
        "copilot-chat"
        "dashboard"
        "fzf"
        "help"
        "ministarter"
        "snacks_dashboard"
      ];
      ignore_terminal = true;
      return_cursor = true;
    };
  };

  keymaps = lib.mkIf config.plugins.whitespace.enable [
    {
      mode = "n";
      key = "<leader>lw";
      action.__raw = "require('whitespace-nvim').trim";
      options = {
        desc = "Whitespace trim";
      };
    }
  ];
}
