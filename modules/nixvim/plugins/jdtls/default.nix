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

        function _G.khanelivim_jdtls.source_paths(root)
          local patterns = {
            root .. "/src/main/java",
            root .. "/src/test/java",
            root .. "/**/src/main/java",
            root .. "/**/src/test/java",
          }
          local paths = {}

          for _, pattern in ipairs(patterns) do
            for _, path in ipairs(vim.fn.glob(pattern, true, true)) do
              if vim.fn.isdirectory(path) == 1 and not vim.tbl_contains(paths, path) then
                table.insert(paths, path)
              end
            end
          end

          if #paths == 0 then
            table.insert(paths, root)
          end

          return paths
        end

        function _G.khanelivim_jdtls.patch_client(client)
          if client._khanelivim_source_paths_patched then
            return
          end

          local original_request = client.request
          client.request = function(self, method, params, handler, bufnr)
            local requested_setting = params
              and params.command == "java.project.getSettings"
              and params.arguments
              and params.arguments[2]
              and params.arguments[2][1]

            if method == "workspace/executeCommand" and requested_setting == "org.eclipse.jdt.ls.core.sourcePaths" then
              local response = {
                ["org.eclipse.jdt.ls.core.sourcePaths"] = _G.khanelivim_jdtls.source_paths(self.config.root_dir),
              }

              if handler then
                vim.schedule(function()
                  handler(nil, response, {
                    bufnr = bufnr,
                    client_id = self.id,
                    method = method,
                  })
                end)
              end

              return true
            end

            return original_request(self, method, params, handler, bufnr)
          end

          client._khanelivim_source_paths_patched = true
        end
      '';

      settings = {
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

        on_init.__raw = ''
          function(client)
            _G.khanelivim_jdtls.patch_client(client)
          end
        '';

        settings = javaSettings;
      };
    };
  };
}
