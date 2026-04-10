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

        init_options = {
          # Temporarily disabled bundles due to OSGi resolution issues in logs
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
            java.configuration.updateBuildConfiguration = "automatic";
          };
      };
    };
  };
}
