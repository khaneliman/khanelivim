{ pkgs, fetchurl }:
{
  java = {
    configuration = {
      updateBuildConfiguration = "interactive";
      runtimes = [
        {
          name = "JavaSE-11";
          path = "${pkgs.jdk11}";
        }
        {
          name = "JavaSE-17";
          path = "${pkgs.jdk17}";
        }
        {
          name = "JavaSE-21";
          path = "${pkgs.jdk21}";
        }
        {
          name = "JavaSE-23";
          path = "${pkgs.jdk}";
          default = true;
        }
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
        url = fetchurl {
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
          sha256 = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
        };
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
}
