{
  config,
  lib,
  ...
}:
{
  imports = [
    ./animate.nix
    ./bufremove.nix
    ./clue.nix
    ./cursorword.nix
    ./diff.nix
    ./files.nix
    ./fuzzy.nix
    ./git.nix
    ./hipatterns.nix
    ./indentscope.nix
    ./map.nix
    ./move.nix
    ./notify.nix
    ./operators.nix
    ./pairs.nix
    ./sessions.nix
    ./splitjoin.nix
    ./starter.nix
    ./surround.nix
    ./trailspace.nix
  ];

  plugins = {
    mini-ai = {
      enable = lib.elem "mini-ai" config.khanelivim.editor.textObjects;
      settings = lib.mkIf (lib.elem "treesitter-textobjects" config.khanelivim.editor.textObjects) {
        custom_textobjects = {
          f = {
            __raw = "require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' })";
          };
          c = {
            __raw = "require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' })";
          };
        };
      };
    };

    mini-align.enable = true;

    mini-basics.enable = true;

    mini-bracketed = {
      enable = true;
      settings = lib.mkIf (lib.elem "treesitter-textobjects" config.khanelivim.editor.textObjects) {
        file.suffix = "";
        comment.suffix = "";
      };
    };

    mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    mini-snippets = lib.mkIf (config.khanelivim.editor.snippet == "mini-snippets") {
      enable = true;
      settings = {
        mappings = {
          # Avoid conflicts with khanelivim's global insert-mode <C-j>/<C-k>/<C-h>/<C-l> movement maps.
          expand = "<C-g><C-j>";
          jump_next = "<C-g><C-l>";
          jump_prev = "<C-g><C-h>";
          stop = "<C-g><C-c>";
        };
        snippets = {
          __unkeyed-1.__raw = lib.mkIf config.plugins.friendly-snippets.enable "require('mini.snippets').gen_loader.from_file('${config.plugins.friendly-snippets.package}/snippets/global.json')";
          __unkeyed-2.__raw = "require('mini.snippets').gen_loader.from_lang()";
        };
      };
    };
  };
}
