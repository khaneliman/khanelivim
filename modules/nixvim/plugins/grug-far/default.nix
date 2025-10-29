{ lib, config, ... }:
{
  plugins = {
    grug-far = {
      enable = config.khanelivim.editor.search == "grug-far";
      lazyLoad = {
        settings = {
          cmd = "GrugFar";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.grug-far.enable [
    {
      mode = "n";
      key = "<leader>rg";
      action = "<cmd>GrugFar<CR>";
      options = {
        desc = "GrugFar toggle";
      };
    }
  ];
}
