{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bigfile.nix
    ./bufdelete.nix
    ./dashboard.nix
    ./debug.nix
    ./dim.nix
    ./gitbrowse.nix
    ./lazygit.nix
    ./notifier.nix
    ./picker.nix
    ./profiler.nix
    ./scope.nix
    ./scratch.nix
    ./terminal.nix
    ./toggle.nix
    ./words.nix
    ./zen.nix
  ];

  extraPackages = with pkgs; [
    # PDF rendering
    ghostscript
    # Mermaid diagrams
    # FIXME: pulls in chromium??
    # mermaid-cli
    # LaTeX
    # FIXME: broken
    # tectonic
  ];

  plugins = {
    snacks = {
      enable = true;

      settings = {
        image.enabled = true;
        indent.enabled = config.khanelivim.ui.indentGuides == "snacks";
        input.enabled = true;
        scroll.enabled = true;
        statuscolumn = {
          enabled = config.khanelivim.ui.statusColumn == "snacks";

          folds = {
            open = true;
            git_hl = lib.elem "gitsigns" config.khanelivim.git.integrations;
          };
        };
        quickfile.enabled = true;
      };
    };
  };
}
