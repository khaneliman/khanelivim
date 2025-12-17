{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.optionals (config.plugins.dap.enable && pkgs.stdenv.hostPlatform.isLinux) [
    pkgs.bashdb
  ];

  plugins = {
    dap = {
      adapters = {
        executables = {
          bashdb = lib.mkIf pkgs.stdenv.hostPlatform.isLinux { command = lib.getExe pkgs.bashdb; };
        };
      };

      configurations = {
        sh = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          {
            type = "bashdb";
            request = "launch";
            name = "Launch (BashDB)";
            showDebugOutput = true;
            pathBashdb = "${lib.getExe pkgs.bashdb}";
            pathBashdbLib = "${pkgs.bashdb}/share/basdhb/lib/";
            trace = true;
            file = ''''${file}'';
            program = ''''${file}'';
            cwd = ''''${workspaceFolder}'';
            pathCat = "cat";
            pathBash = "${lib.getExe pkgs.bash}";
            pathMkfifo = "mkfifo";
            pathPkill = "pkill";
            args = { };
            env = { };
            terminalKind = "integrated";
          }
        ];
      };

    };
  };

}
