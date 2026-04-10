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
    pkgs.jdt-language-server
    pkgs.maven
    pkgs.gradle
    pkgs.unzip
    pkgs.lombok
  ];

  extraPlugins = lib.mkIf javaEnabled [
    # TODO: upstream dependency
    pkgs.vimPlugins.spring-boot-nvim
  ];

  plugins = {
    java = {
      enable = javaEnabled;

      settings = {
        # Use common settings or nvim-java specifics
        verification.invalid_packages = false;
      };
    };

    lsp.servers.jdtls = {
      enable = javaEnabled;
      settings = import ../jdtls/java-settings.nix {
        inherit pkgs;
        inherit (pkgs) fetchurl;
      };
      cmd = [
        (lib.getExe pkgs.jdt-language-server)
        "-data"
        {
          __raw = ''
            (function()
              local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
              local root = require("jdtls.setup").find_root(root_markers)
              return vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root or vim.fn.getcwd())
            end)()
          '';
        }
        "-javaagent:${pkgs.lombok}/share/java/lombok.jar"
        "-vmargs"
        "-Xmx4G"
        "-XX:+UseG1GC"
      ];
    };
  };
}
