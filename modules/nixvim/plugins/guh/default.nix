{
  config,
  lib,
  pkgs,
  ...
}:
let
  # guh.nvim requires Nvim 0.13+.
  hasNeovim013OrNewer = lib.versionAtLeast (pkgs.neovim.version or "0.0") "0.13";
  isEnabled = lib.elem "guh" config.khanelivim.git.integrations && hasNeovim013OrNewer;
in
{
  config = lib.mkIf isEnabled {
    # See: https://github.com/justinmk/guh.nvim
    dependencies.gh.enable = lib.mkDefault true;

    extraPlugins = [
      {
        plugin = pkgs.vimPlugins.guh-nvim;
        optional = config.plugins.lz-n.enable;
      }
    ];

    plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
      {
        __unkeyed-1 = "guh.nvim";
        cmd = [ "Guh" ];
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>gvg";
        action = "<cmd>Guh<CR>";
        options.desc = "Guh";
      }
    ];
  };
}
