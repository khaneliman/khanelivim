{ config, lib, ... }:
{
  plugins = {
    # friendly-snippets documentation
    # See: https://github.com/rafamadriz/friendly-snippets
    friendly-snippets.enable = lib.mkDefault true;
  };

  plugins.luasnip.filetypeExtend =
    lib.mkIf (config.plugins.friendly-snippets.enable && config.khanelivim.editor.snippet == "luasnip")
      {
        typescript = [
          "angular"
          "remix-ts"
        ];
        typescriptreact = [
          "angular"
          "remix-ts"
        ];
        html = [ "angular" ];
        cs = [ "unity" ];
        cpp = [ "unreal" ];
      };
}
