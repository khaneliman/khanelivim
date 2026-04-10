{ lib, ... }:
let
  runtimeFiletypes = [
    "gd"
    "gdscript3"
    "gotmpl"
    "markdown.mdx"
    "qmljs"
    "teal"
    "yaml.docker-compose"
    "yaml.gitlab"
    "yaml.helm-values"
  ];

  mkRuntimeFiletype = filetype: {
    name = "ftplugin/${filetype}.vim";
    value.source = builtins.toFile "${filetype}.vim" ''
      " Register filetypes advertised by nvim-lspconfig so vim.lsp health
      " does not flag them as unknown. Detection still comes from filetype rules.
    '';
  };
in
{
  extraFiles = lib.mkMerge [
    (lib.listToAttrs (map mkRuntimeFiletype runtimeFiletypes))
    {
      "lua/khanelivim/tooling_info.lua".source = ./lua/khanelivim/tooling_info.lua;
      "lua/khanelivim/web_tools.lua".source = ./lua/khanelivim/web_tools.lua;
    }
  ];

  # Just a small boolean function to convert a boolean to a string
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';
}
