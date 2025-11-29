{
  config,
  lib,
  ...
}:
let
  zenEnabled = config.khanelivim.ui.zenMode == "no-neck-pain";
in
{
  plugins = {
    no-neck-pain = {
      enable = zenEnabled;
      settings = {
        # Center the focused window with reasonable width
        # width = 120;

        # Auto-enable settings
        autocmds = {
          # Skip entering the side buffers
          # skipEnteringNoNeckPainBuffer = true;
        };
      };
    };
  };

  keymaps =
    (lib.optionals zenEnabled [
      # Unified zen mode toggle
      {
        mode = "n";
        key = "<leader>uZ";
        action = "<cmd>NoNeckPain<CR>";
        options = {
          desc = "Toggle Zen Mode";
        };
      }
    ])
    ++ (lib.optionals config.plugins.no-neck-pain.enable [
      {
        mode = "n";
        key = "<leader>unt";
        action = "<cmd>NoNeckPain<CR>";
        options = {
          desc = "Toggle No Neck Pain";
        };
      }
      {
        mode = "n";
        key = "<leader>unl";
        action = "<cmd>NoNeckPainToggleLeftSide<CR>";
        options = {
          desc = "Toggle Left Side Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>unr";
        action = "<cmd>NoNeckPainToggleRightSide<CR>";
        options = {
          desc = "Toggle Right Side Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>un=";
        action = "<cmd>NoNeckPainWidthUp<CR>";
        options = {
          desc = "Increase Width";
        };
      }
      {
        mode = "n";
        key = "<leader>un-";
        action = "<cmd>NoNeckPainWidthDown<CR>";
        options = {
          desc = "Decrease Width";
        };
      }
      {
        mode = "n";
        key = "<leader>uns";
        action = "<cmd>NoNeckPainScratchPad<CR>";
        options = {
          desc = "Toggle ScratchPad";
        };
      }
    ]);
}
