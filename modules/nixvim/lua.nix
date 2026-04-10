{
  extraFiles = {
    "ftplugin/teal.vim".source = builtins.toFile "teal.vim" ''
      " Register Teal as a known runtime filetype so vim.lsp health checks stop
      " flagging it as unknown. Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/gd.vim".source = builtins.toFile "gd.vim" ''
      " nvim-lspconfig's gdscript config advertises this legacy GDScript alias.
      " Keep *.gd detection on Neovim's gdscript filetype.
    '';
    "ftplugin/gdscript3.vim".source = builtins.toFile "gdscript3.vim" ''
      " nvim-lspconfig's gdscript config advertises this Godot 3 GDScript alias.
      " Keep real detection on Neovim's gdscript filetype.
    '';
    "ftplugin/gotmpl.vim".source = builtins.toFile "gotmpl.vim" ''
      " nvim-lspconfig's gopls config advertises Go template support.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/markdown.mdx.vim".source = builtins.toFile "markdown.mdx.vim" ''
      " nvim-lspconfig's marksman config advertises MDX as a Markdown subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/qmljs.vim".source = builtins.toFile "qmljs.vim" ''
      " nvim-lspconfig's qmlls config advertises this QML JavaScript alias.
      " Keep real detection on Neovim's qml filetype unless a qmljs extension is needed.
    '';
    "ftplugin/yaml.docker-compose.vim".source = builtins.toFile "yaml.docker-compose.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/yaml.gitlab.vim".source = builtins.toFile "yaml.gitlab.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/yaml.helm-values.vim".source = builtins.toFile "yaml.helm-values.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "lua/khanelivim/tooling_info.lua".source = ./lua/khanelivim/tooling_info.lua;
    "lua/khanelivim/web_tools.lua".source = ./lua/khanelivim/web_tools.lua;
  };

  # Just a small boolean function to convert a boolean to a string
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';
}
