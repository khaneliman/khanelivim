{ config, lib, ... }:
{
  plugins = {
    mini-fuzzy.enable = true;

    telescope = {
      settings = {
        defaults = lib.mkIf config.plugins.mini-fuzzy.enable {
          file_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
          generic_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
        };
      };
    };
  };
}
