{
  pkgs,
  ...
}:
{
  # TODO: upstream module
  extraPlugins = [ pkgs.vimPlugins.glance-nvim ];
  extraConfigLua = ''
    require('glance').setup()
  '';
  plugins = {
    which-key.settings.spec = [
      {
        __unkeyed = "<leader>lg";
        group = "Glance";
        icon = "󰍉";
      }
    ];
  };

  keymaps = [
    {
      action = "<CMD>Glance definitions<CR>";
      mode = "n";
      key = "<leader>lgd";
      options = {
        desc = "Glance definition";
      };
    }
    {
      action = "<CMD>Glance implementations<CR>";
      mode = "n";
      key = "<leader>lgi";
      options = {
        desc = "Glance implementation";
      };
    }
    {
      action = "<CMD>Glance references<CR>";
      mode = "n";
      key = "<leader>lgr";
      options = {
        desc = "Glance reference";
      };
    }
    {
      action = "<CMD>Glance type_definitions<CR>";
      mode = "n";
      key = "<leader>lgt";
      options = {
        desc = "Glance type definition";
      };
    }
  ];
}
