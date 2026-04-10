{
  config,
  lib,
  pkgs,
  ...
}:
let
  javaEnabled = config.khanelivim.lsp.java == "nvim-java";
in
{
  extraPackages = lib.mkIf javaEnabled [
    pkgs.jdk
    pkgs.unzip
  ];

  extraPlugins = lib.mkIf javaEnabled [
    # TODO: upstream dependency
    pkgs.vimPlugins.spring-boot-nvim
  ];

  plugins.java = {
    enable = javaEnabled;

    settings = {
      # TODO: configure
    };
  };
}
