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
    package = pkgs.vimPlugins.spring-boot-nvim.overrideAttrs (old: {
      postPatch = ''
        ${old.postPatch or ""}

        substituteInPlace lua/spring_boot.lua \
          --replace-fail '          return result' '          return result == nil and vim.NIL or result'
      '';
    });

    settings = {
      java_cmd = "${pkgs.jdk}/bin/java";
      ls_path = "${springBootLanguageServer}/language-server/spring-boot-language-server.jar";
      jdtls_name = "jdtls";
    };
  };

  extraConfigLuaPre = lib.mkIf javaEnabled ''
    _G.khanelivim_spring_boot_jdtls_bundles = function()
      return require("spring_boot").java_extensions("${springBootLanguageServer}/jars")
    end
  '';
}
