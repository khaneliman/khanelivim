{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.mkIf (config.khanelivim.lsp.java == "nvim-jdtls") [
    pkgs.jdk
    pkgs.jdt-language-server
    pkgs.lombok
    pkgs.maven
    pkgs.gradle
    pkgs.unzip
  ];

  plugins = {
    jdtls = {
      # nvim-jdtls documentation
      # See: https://github.com/mfussenegger/nvim-jdtls
      enable = config.khanelivim.lsp.java == "nvim-jdtls";

      lazyLoad.settings.ft = "java";

      settings = {
        cmd = [
          (lib.getExe pkgs.jdt-language-server)
          "-data"
          {
            __raw = ''
              (function()
                local root = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})
                return vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root or vim.fn.getcwd())
              end)()
            '';
          }
          "-javaagent:${pkgs.lombok}/share/java/lombok.jar"
          "-vmargs"
          "-Xmx2G"
          "-XX:+UseG1GC"
        ];

        init_options = {
          bundles = [ ];
          extendedClientCapabilities = {
            progressReportProvider = true;
            classFileContentsSupport = true;
            generateToStringPromptSupport = true;
            hashCodeEqualsPromptSupport = true;
            advancedExtractInterfaceSupport = true;
            advancedOrganizeImportsSupport = true;
            generateConstructorsPromptSupport = true;
            generateDelegateMethodsPromptSupport = true;
          };
        };

        root_dir.__raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})";

        capabilities = {
          textDocument = {
            semanticTokens = {
              dynamicRegistration = false;
            };
          };
        };

        settings =
          (import ./java-settings.nix {
            inherit pkgs;
            inherit (pkgs) fetchurl;
          })
          // {
            java = {
              configuration.updateBuildConfiguration = "automatic";
              import = {
                maven.enabled = true;
                gradle.enabled = true;
              };
            };
          };
      };
    };
  };
}
