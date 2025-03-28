{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "vs-tasks.nvim";
      version = "2025-03-17";
      src = pkgs.fetchFromGitHub {
        owner = "EthanJWright";
        repo = "vs-tasks.nvim";
        rev = "f0a10214ca3856fb4387db4f11acbaafa9ed3515";
        sha256 = "0k00n8p9cy2g98a8g5dg9c67sa0hx1shjj0hhpw8yac4rj5dbgdl";
      };
      meta.homepage = "https://github.com/EthanJWright/vs-tasks.nvim/";
      meta.hydraPlatforms = [ ];
      dependencies = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-nvim
      ];
    })
  ];

  plugins.telescope = {
    luaConfig.post = ''
      require("vstask").setup()
      require("telescope").load_extension("vstask")
    '';
  };

  keymaps = lib.mkIf (config.plugins.telescope.enable && (!config.plugins.overseer.enable)) [
    {
      mode = "n";
      key = "<leader>RT";
      action = "<cmd>Telescope vstask tasks<CR>";
      options = {
        desc = "Find tasks";
      };
    }
  ];
}
