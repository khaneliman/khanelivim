{ config, lib, ... }:
{
  plugins = {
    mini = {
      enable = true;

      modules = {
        fuzzy = { };
      };
    };

    telescope = {
      settings = {
        defaults =
          lib.mkIf (config.plugins.mini.enable && lib.hasAttr "fuzzy" config.plugins.mini.modules)
            {
              file_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
              generic_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
            };
      };
    };
  };
}
