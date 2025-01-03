{ lib, config, ... }:
{
  plugins = {
    grug-far = {
      enable = true;
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
