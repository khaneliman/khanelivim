{
  config,
  lib,
  ...
}:
{
  imports = [
    ./bigfile.nix
    ./bufdelete.nix
    ./dashboard.nix
    ./debug.nix
    ./dim.nix
    ./gh.nix
    ./gitbrowse.nix
    ./image.nix
    ./lazygit.nix
    ./notifier.nix
    ./picker.nix
    ./profiler.nix
    ./rename.nix
    ./scope.nix
    ./scratch.nix
    ./terminal.nix
    ./toggle.nix
    ./words.nix
    ./zen.nix
  ];

  plugins = {
    # snacks.nvim documentation
    # See: https://github.com/folke/snacks.nvim
    snacks = {
      enable = true;

      settings = {
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
        styles = lib.mkIf (config.khanelivim.ui.renamePopup == "snacks") {
          input = {
            relative = "cursor";
            row = -4;
            col = 0;
          };
        };
      };
    };
  };
}
