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

    lazyLoad.settings.ft = [ "java" ];

    luaConfig.pre = ''
      _G.khanelivim_jdtls = _G.khanelivim_jdtls or {}

      function _G.khanelivim_jdtls.find_root(startpath)
        local current = startpath and vim.fs.dirname(startpath) or nil
        local gradle_settings_root = nil
        local nearest_maven_root = nil
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

        return gradle_settings_root or nearest_maven_root or nearest_gradle_root
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
        ""
        "-configuration"
        ""
        "-javaagent:${pkgs.lombok}/share/java/lombok.jar"
        "-vmargs"
        "-Xmx4G"
        "-XX:+UseG1GC"
      ];

      on_new_config.__raw = ''
        function(new_config, root_dir)
          new_config.cmd = {
            "${lib.getExe pkgs.jdt-language-server}",
            "-data",
            _G.khanelivim_jdtls.workspace_dir(root_dir, "data"),
            "-configuration",
            _G.khanelivim_jdtls.workspace_dir(root_dir, "config"),
            "-javaagent:${pkgs.lombok}/share/java/lombok.jar",
            "-vmargs",
            "-Xmx4G",
            "-XX:+UseG1GC",
          }
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
    };
  };
}
