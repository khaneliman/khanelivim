{ pkgs, ... }:
{
  extraConfigLuaPre =
    let
      java-debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
      java-test = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
    in
    ''
      local jdtls = require("jdtls")
      local jdtls_dap = require("jdtls.dap")
      local jdtls_setup = require("jdtls.setup")

      _M.jdtls = {}
      _M.jdtls.bundles = {}

      local java_debug_bundle = vim.split(vim.fn.glob("${java-debug}" .. "/*.jar"), "\n")
      local java_test_bundle = vim.split(vim.fn.glob("${java-test}" .. "/*.jar", true), "\n")

      -- add jars to the bundle list if there are any
      if java_debug_bundle[1] ~= "" then
          vim.list_extend(_M.jdtls.bundles, java_debug_bundle)
      end

      if java_test_bundle[1] ~= "" then
          vim.list_extend(_M.jdtls.bundles, java_test_bundle)
      end
    '';

  plugins = {
    nvim-jdtls = {
      enable = true;
      configuration.__raw = ''vim.fn.stdpath 'cache' .. "/jdtls/config"'';
      data.__raw = "vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')";
      initOptions = {
        bundles.__raw = "_M.jdtls.bundles";
        # FIXME: not working
        # bundles = {
        #   __unkeyed-1.__raw = ''vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1)'';
        #   __unkeyed-2.__raw = ''vim.split(vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1), "\n")'';
        # };
      };
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive";
            runtimes = [
              pkgs.jdk11
              pkgs.jdk17
              pkgs.jdk
            ];
          };
          codeGeneration = {
            toString = {
              # template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
              useBlocks = true;
            };
          };
          contentProvider = { };
          completion = {
            favoriteStaticMembers = [
              "org.hamcrest.MatcherAssert.assertThat"
              "org.hamcrest.Matchers.*"
              "org.hamcrest.CoreMatchers.*"
              "org.junit.jupiter.api.Assertions.*"
              "java.util.Objects.requireNonNull"
              "java.util.Objects.requireNonNullElse"
              "org.mockito.Mockito.*"
            ];
            filteredTypes = [
              "com.sun.*"
              "io.micrometer.shaded.*"
              "java.awt.*"
              "jdk.*"
              "sun.*"
            ];
            importOrder = [
              "java"
              "javax"
              "com"
              "org"
            ];
          };
          eclipse = {
            downloadSources = true;
          };
          format = {
            enabled = true;
            settings = {
              url = "${
                (pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
                  sha256 = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
                })
              }";
              profile = "GoogleStyle";
            };
          };
          implementationCodeLens = {
            enabled = true;
          };
          import = {
            gradle = {
              enabled = true;
              wrapper = {
                enabled = true;
              };
            };
            maven = {
              enabled = true;
            };
          };
          inlayHints = {
            parameterNames = {
              enabled = "all";
            };
          };
          maven = {
            downloadSources = true;
          };
          references = {
            includeDecompiledSources = true;
          };
          referencesCodeLens = {
            enabled = true;
          };
          signatureHelp = {
            enabled = true;
          };
          preferred = "fernflower";
          sources = {
            organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            };
          };
        };
      };
    };
  };

}
