{
  config,
  lib,
  self,
  ...
}:
{
  imports = self.lib.khanelivim.readAllFiles ./mini;

  plugins = {
    mini = {
      enable = true;
      mockDevIcons = true;

      modules = {
        ai = { };
        align = { };
        basics = { };
        bracketed = { };
        git = { };
        icons = { };
        snippets = {
          snippets = {
            __unkeyed-1.__raw =
              lib.mkIf config.plugins.friendly-snippets.enable # Lua
                "require('mini.snippets').gen_loader.from_file('${config.plugins.friendly-snippets.package}/snippets/global.json')";
            __unkeyed-2.__raw = "require('mini.snippets').gen_loader.from_lang()";
          };
        };
      };
    };
  };
}
