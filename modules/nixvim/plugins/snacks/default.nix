{
  config,
  ...
}:
{
  imports = [
    ./bigfile.nix
    ./bufdelete.nix
    ./gitbrowse.nix
    ./lazygit.nix
    ./picker.nix
    ./profiler.nix
    ./zen.nix
  ];

  plugins = {
    snacks = {
      enable = true;

      settings = {
        indent.enabled = true;
        scroll.enabled = true;
        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = config.plugins.gitsigns.enable;
          };
        };
      };
    };
  };
}
