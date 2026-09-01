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

  plugins.java = {
    enable = javaEnabled;
    package = pkgs.vimPlugins.nvim-java.overrideAttrs (old: {
      postPatch = ''
        ${old.postPatch or ""}

        substituteInPlace lua/java.lua \
          --replace-fail "local pkgm = Manager()" "local pkgm = config.pkgm and config.pkgm.enable == false and { install = function() end } or Manager()" \
          --replace-fail "require('java.startup.lsp_setup').setup(config)" "if config.jdtls.enable ~= false then
          require('java.startup.lsp_setup').setup(config)
        end"

        substituteInPlace lua/java-refactor/api/refactor.lua \
          --replace-fail "diagnostics = vim.lsp.diagnostic.get_line_diagnostics(0)," ""
      '';
    });

    lazyLoad.settings.ft = [ "java" ];

    luaConfig.pre = ''
      _G.khanelivim_jdtls = _G.khanelivim_jdtls or {}

      function _G.khanelivim_jdtls.find_root(startpath)
        local current = startpath and vim.fs.dirname(startpath) or nil
        local gradle_settings_root = nil
        local git_root = nil
        local maven_root = nil
        local nearest_gradle_root = nil

        while current and current ~= "" and current ~= "." do
          local has_gradle_settings =
            vim.uv.fs_stat(current .. "/settings.gradle")
            or vim.uv.fs_stat(current .. "/settings.gradle.kts")
          local has_maven_root =
            vim.uv.fs_stat(current .. "/pom.xml")
            or vim.uv.fs_stat(current .. "/mvnw")
          local has_gradle_root =
            vim.uv.fs_stat(current .. "/build.gradle")
            or vim.uv.fs_stat(current .. "/build.gradle.kts")
            or vim.uv.fs_stat(current .. "/gradlew")

          if has_gradle_settings then
            gradle_settings_root = current
          end

          if has_maven_root then
            maven_root = current
          end

          if not nearest_gradle_root and has_gradle_root then
            nearest_gradle_root = current
          end

          if vim.uv.fs_stat(current .. "/.git") then
            git_root = current
            break
          end

          local parent = vim.fs.dirname(current)
          if not parent or parent == current then
            break
          end

          current = parent
        end

        return gradle_settings_root or (maven_root and git_root) or maven_root or nearest_gradle_root
      end

      function _G.khanelivim_jdtls.find_root_for_buffer(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == "" then
          return nil
        end

        return _G.khanelivim_jdtls.find_root(path)
      end

      function _G.khanelivim_jdtls.workspace_dir(root, kind)
        return vim.fn.stdpath("cache")
          .. "/jdtls/"
          .. vim.fn.sha256(root)
          .. "/"
          .. kind
      end

      function _G.khanelivim_jdtls.is_large_gradle_workspace(root)
        if not root then
          return false
        end

        local has_gradle_settings =
          vim.uv.fs_stat(root .. "/settings.gradle")
          or vim.uv.fs_stat(root .. "/settings.gradle.kts")

        if not has_gradle_settings then
          return false
        end

        local project_count = 0

        for name, entry_type in vim.fs.dir(root) do
          if entry_type == "directory" then
            local path = root .. "/" .. name
            if vim.uv.fs_stat(path .. "/build.gradle") or vim.uv.fs_stat(path .. "/build.gradle.kts") then
              project_count = project_count + 1
            end
          end
        end

        return project_count >= 2
      end

    '';

    settings = {
      # Keep JDK management in Nix
      jdk.auto_install = false;
      # Keep nvim-java's feature APIs, but use the Nix-managed JDTLS below.
      jdtls.enable = false;
      pkgm.enable = false;
      # Spring Boot is configured by the root spring-boot plugin module.
      spring_boot_tools = {
        enable = false;
      };
      root_markers = [
        "pom.xml"
        "mvnw"
        "settings.gradle"
        "settings.gradle.kts"
        "build.gradle"
        "build.gradle.kts"
        "gradlew"
      ];
    };
  };

  lsp.servers.jdtls = lib.mkIf javaEnabled {
    enable = true;
    config = {
      cmd.__raw = ''
        function(dispatchers, lsp_config)
          local root = assert(lsp_config.root_dir, "JDTLS root not found")

          return vim.lsp.rpc.start({
            "${lib.getExe pkgs.jdt-language-server}",
            "-data",
            _G.khanelivim_jdtls.workspace_dir(root, "data"),
            "-configuration",
            _G.khanelivim_jdtls.workspace_dir(root, "config"),
            "-javaagent:${pkgs.lombok}/share/java/lombok.jar",
            "-vmargs",
            "-Xmx4G",
            "-XX:+UseG1GC",
          }, dispatchers, {
            cwd = lsp_config.cmd_cwd or root,
            env = lsp_config.cmd_env,
            detached = lsp_config.detached,
          })
        end
      '';

      root_dir.__raw = ''
        function(bufnr, on_dir)
          local root = _G.khanelivim_jdtls.find_root_for_buffer(bufnr)
          if root then
            on_dir(root)
          end
        end
      '';

      init_options = {
        bundles.__raw = ''
          (function()
            local function extension_bundles(root)
              local package_json = vim.json.decode(
                table.concat(vim.fn.readfile(root .. "/package.json"), "\n")
              )

              return vim.tbl_map(function(relative_path)
                return root .. "/" .. relative_path:gsub("^%./", "")
              end, package_json.contributes.javaExtensions)
            end

            local debug_root =
              "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug"
            local test_root =
              "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test"
            local bundles = vim
              .iter({
                extension_bundles(debug_root),
                extension_bundles(test_root),
              })
              :flatten()
              :totable()

            if _G.khanelivim_spring_boot_jdtls_bundles then
              vim.list_extend(bundles, _G.khanelivim_spring_boot_jdtls_bundles())
            end

            return bundles
          end)()
        '';

        extendedClientCapabilities = {
          actionableRuntimeNotificationSupport = true;
          advancedExtractRefactoringSupport = true;
          advancedGenerateAccessorsSupport = true;
          advancedIntroduceParameterRefactoringSupport = true;
          advancedOrganizeImportsSupport = true;
          advancedUpgradeGradleSupport = true;
          classFileContentsSupport = true;
          clientDocumentSymbolProvider = false;
          clientHoverProvider = false;
          executeClientCommandSupport = true;
          extractInterfaceSupport = true;
          generateConstructorsPromptSupport = true;
          generateDelegateMethodsPromptSupport = true;
          generateToStringPromptSupport = true;
          gradleChecksumWrapperPromptSupport = true;
          hashCodeEqualsPromptSupport = true;
          inferSelectionSupport = [
            "extractConstant"
            "extractField"
            "extractInterface"
            "extractMethod"
            "extractVariableAllOccurrence"
            "extractVariable"
          ];
          moveRefactoringSupport = true;
          onCompletionItemSelectedCommand = "editor.action.triggerParameterHints";
          overrideMethodsPromptSupport = true;
        };
      };
    };
  };
}
