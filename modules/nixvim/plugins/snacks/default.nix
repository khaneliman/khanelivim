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
    ./gitbrowse.nix
    ./lazygit.nix
    ./picker.nix
    ./profiler.nix
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
        scroll.enabled = true;
        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = lib.elem "gitsigns" config.khanelivim.git.integrations;
          };
        };
      };
    };
  };
}
