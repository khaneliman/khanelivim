{
  config,
  lib,
  pkgs,
  self,
  system,
  ...
}:
let
  javaEnabled = config.khanelivim.lsp.java == "nvim-java";
  springBootLanguageServer = self.packages.${system}.spring-boot-language-server;
in
{
  plugins.spring-boot = {
    enable = javaEnabled;

    settings = {
      java_cmd = "${pkgs.jdk}/bin/java";
      ls_path = "${springBootLanguageServer}/language-server/spring-boot-language-server-2.2.0-SNAPSHOT-exec.jar";
      jdtls_name = "jdtls";
    };
  };

  extraConfigLuaPre = lib.mkIf javaEnabled ''
    _G.khanelivim_spring_boot_jdtls_bundles = function()
      return require("spring_boot").java_extensions("${springBootLanguageServer}/jars")
    end
  '';
}
