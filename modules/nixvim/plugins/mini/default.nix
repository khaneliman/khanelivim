{
  config,
  lib,
  ...
}:
{
  imports = [
    ./bufremove.nix
    ./comment.nix
    ./diff.nix
    ./files.nix
    ./fuzzy.nix
    ./git.nix
    ./hipatterns.nix
    ./indentscope.nix
    ./map.nix
    ./pairs.nix
    ./starter.nix
    ./surround.nix
  ];

  plugins = {
    mini = {
      enable = true;

      modules = {
        basics = { };
        bracketed = { };
        snippets = lib.mkIf (config.khanelivim.editor.snippetEngine == "mini-snippets") {
          snippets = {
            __unkeyed-1.__raw =
              lib.mkIf config.plugins.friendly-snippets.enable # Lua
                "require('mini.snippets').gen_loader.from_file('${config.plugins.friendly-snippets.package}/snippets/global.json')";
            __unkeyed-2.__raw = "require('mini.snippets').gen_loader.from_lang()";
          };
        };
      };
    };

    mini-ai.enable = true;
    mini-align.enable = true;
    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };
  };
}
