{
  config,
  self,
  system,
  ...
}:
{
  imports = [
    ./bigfile.nix
    ./bufdelete.nix
    # FIXME: inf recursion trying to logic gate
    # ./dashboard.nix
    ./gitbrowse.nix
    ./lazygit.nix
    ./picker.nix
    ./profiler.nix
    ./zen.nix
  ];

  plugins = {
    snacks = {
      enable = true;
      package = self.packages.${system}.snacks-nvim;

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
