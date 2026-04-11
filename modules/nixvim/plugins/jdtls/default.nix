{
  config,
  lib,
  pkgs,
  ...
}:
let
  javaSettings = lib.recursiveUpdate
    (import ./java-settings.nix {
      inherit pkgs;
      inherit (pkgs) fetchurl;
    })
    {
      java.configuration.updateBuildConfiguration = "automatic";
    };
in
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

      luaConfig.pre = ''
        _G.khanelivim_jdtls = _G.khanelivim_jdtls or {}

        function _G.khanelivim_jdtls.find_root()
          local bufname = vim.api.nvim_buf_get_name(0)
          local current = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd()
          local highest_java_root = nil

          while current and current ~= "" do
            local has_java_build_root =
              vim.uv.fs_stat(current .. "/pom.xml")
              or vim.uv.fs_stat(current .. "/mvnw")
              or vim.uv.fs_stat(current .. "/build.gradle")
              or vim.uv.fs_stat(current .. "/build.gradle.kts")
              or vim.uv.fs_stat(current .. "/settings.gradle")
              or vim.uv.fs_stat(current .. "/settings.gradle.kts")
              or vim.uv.fs_stat(current .. "/gradlew")

            if has_java_build_root then
              highest_java_root = current
            end

            if vim.uv.fs_stat(current .. "/.git") then
              break
            end

            local parent = vim.fs.dirname(current)
            if not parent or parent == current then
              break
            end

            current = parent
          end

          return highest_java_root or vim.uv.cwd()
        end

        function _G.khanelivim_jdtls.workspace_dir(kind)
          return vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. vim.fn.sha256(_G.khanelivim_jdtls.find_root())
            .. "/"
            .. kind
        end
      '';

      settings = lib.recursiveUpdate {
        cmd = [
          (lib.getExe pkgs.jdt-language-server)
          "-data"
          {
            __raw = "_G.khanelivim_jdtls.workspace_dir('data')";
          }
          "-configuration"
          {
            __raw = "_G.khanelivim_jdtls.workspace_dir('config')";
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

        root_dir.__raw = "_G.khanelivim_jdtls.find_root()";

        capabilities = {
          textDocument = {
            semanticTokens = {
              dynamicRegistration = false;
            };
          };
        };
      } javaSettings;
    };
  };
}
