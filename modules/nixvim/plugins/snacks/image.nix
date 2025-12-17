{
  config,
  pkgs,
  lib,
  ...
}:
let
  imageEnabled =
    config.plugins.snacks.enable
    && lib.hasAttr "image" config.plugins.snacks.settings
    && config.plugins.snacks.settings.image.enabled or false;
in
{
  # Set Chromium path for mermaid-cli on Darwin (chromium not available in nixpkgs for aarch64-darwin)
  env = lib.optionalAttrs (pkgs.stdenv.isDarwin && imageEnabled) {
    PUPPETEER_EXECUTABLE_PATH = "/Applications/Chromium.app/Contents/MacOS/Chromium";
  };

  extraPackages = lib.optionals imageEnabled (
    with pkgs;
    [
      # Image conversion (required for image module)
      imagemagick
      # PDF rendering
      ghostscript
      # Mermaid diagrams (requires Chromium from Homebrew on Darwin)
      # TODO: figure out no chromium
      # mermaid-cli
      # Math expression rendering
      typst
      # LaTeX for math expressions
      tectonic
    ]
  );

  plugins = {
    snacks = {
      settings = {
        image = {
          enabled = true;
          doc = {
            enabled = true;
            inline = true;
            float = true;
            max_width = 100;
            max_height = 50;
          };
        };
      };
    };
  };
}
