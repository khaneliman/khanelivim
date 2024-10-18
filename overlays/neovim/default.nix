{ inputs, ... }:
(
  self: _super:
  let
    inherit (inputs) neovim-nightly-overlay;
  in
  {
    neovim-unwrapped = neovim-nightly-overlay.packages.${self.system}.default;
  }
)
