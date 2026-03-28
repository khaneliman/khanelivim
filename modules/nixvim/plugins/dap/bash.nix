{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isUnix;
  bashDebugExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "bash-debug";
      publisher = "rogalmic";
      version = "0.3.9";
      hash = "sha256-f8FUZCvz/PonqQP9RCNbyQLZPnN5Oce0Eezm/hD19Fg=";
    };
  };
  bashDebugExtensionPath = "${bashDebugExtension}/share/vscode/extensions/rogalmic.bash-debug";
  bundledBashdb = "${bashDebugExtensionPath}/bashdb_dir/bashdb";
  bundledBashdbLib = "${bashDebugExtensionPath}/bashdb_dir";
  pathPkill = if isDarwin then "/usr/bin/pkill" else lib.getExe' pkgs.procps "pkill";
in
{
  plugins = lib.mkIf (config.plugins.dap.enable && isUnix) {
    dap = {
      adapters = {
        servers = {
          bashdb = {
            host = "127.0.0.1";
            port = "\${port}";
            executable = {
              command = lib.getExe pkgs.nodejs;
              args = [
                "${bashDebugExtensionPath}/out/bashDebug.js"
                "--server=\${port}"
              ];
            };
          };
        };
      };

      configurations = {
        sh = [
          {
            # Primary config
            type = "bashdb";
            request = "launch";
            name = "Launch (BashDB)";
            # Ancillary options
            args.__raw = "{}";
            argsString.__raw = "\"\"";
            cwd = "\${workspaceFolder}";
            env.__raw = "{}";
            inherit pathPkill;
            pathBash = lib.getExe pkgs.bash;
            pathBashdb = bundledBashdb;
            pathBashdbLib = bundledBashdbLib;
            pathCat = lib.getExe' pkgs.coreutils "cat";
            pathMkfifo = lib.getExe' pkgs.coreutils "mkfifo";
            program = "\${file}";
            showDebugOutput = true;
            terminalKind = "integrated";
            trace = true;
          }
        ];
      };
    };
  };
}
