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

  plugins.java = {
    enable = javaEnabled;

    luaConfig.pre = ''
      _G.khanelivim_jdtls = _G.khanelivim_jdtls or {}

      function _G.khanelivim_jdtls.find_root()
        local bufname = vim.api.nvim_buf_get_name(0)
        local current = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd()
        local gradle_settings_root = nil
        local nearest_maven_root = nil
        local nearest_gradle_root = nil

        while current and current ~= "" do
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

          if not nearest_maven_root and has_maven_root then
            nearest_maven_root = current
          end

          if not nearest_gradle_root and has_gradle_root then
            nearest_gradle_root = current
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

        return gradle_settings_root or nearest_maven_root or nearest_gradle_root or vim.uv.cwd()
      end

      function _G.khanelivim_jdtls.workspace_dir(kind)
        return vim.fn.stdpath("cache")
          .. "/jdtls/"
          .. vim.fn.sha256(_G.khanelivim_jdtls.find_root())
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

      _G.khanelivim_jdtls.status = _G.khanelivim_jdtls.status or { id = nil, message = nil }

      function _G.khanelivim_jdtls.status_notify(message)
        if not message or message == "" or message == _G.khanelivim_jdtls.status.message then
          return
        end

        local id = vim.notify(message, vim.log.levels.INFO, {
          title = "jdtls",
          replace = _G.khanelivim_jdtls.status.id,
          hide_from_history = true,
          timeout = false,
        })

        _G.khanelivim_jdtls.status.id = id
        _G.khanelivim_jdtls.status.message = message
      end
    '';

    settings = {
      # Keep JDK management in Nix
      jdk.auto_install = false;
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

      root_dir.__raw = "_G.khanelivim_jdtls.find_root()";

      handlers = {
        "language/status".__raw = ''
          function(_, data)
            local message = data and data.message
            if message and message ~= "" then
              _G.khanelivim_jdtls.status_notify(message)
            end
          end
        '';
      };
    };
  };
}
