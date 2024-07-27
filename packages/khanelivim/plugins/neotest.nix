{ config, lib, ... }:
{

  plugins.neotest = {
    enable = true;

    settings = {
      adapters = lib.optionals config.plugins.rustaceanvim.enable [
        # lua
        ''require('rustaceanvim.neotest')''
      ];
    };

    adapters = {
      bash.enable = true;
      deno.enable = true;
      dotnet.enable = true;
      go.enable = true;
      java.enable = true;
      # NOTE: just run NeotestJava setup
      # java.settings = {
      # Not sure why this wasn't working
      # junit_jar =
      #   pkgs.fetchurl
      #     {
      #       url = "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.1/junit-platform-console-standalone-1.10.1.jar";
      #       hash = "sha256-tC6qU9E1dtF9tfuLKAcipq6eNtr5X0JivG6W1Msgcl8=";
      #     }
      #     .outPath;
      # };
      jest.enable = true;
      playwright.enable = true;
      plenary.enable = true;
      python.enable = true;
      # rust.enable = true;
      zig.enable = true;
    };
  };

  keymaps = lib.mkIf config.plugins.neotest.enable [
    {
      mode = "n";
      key = "<leader>uT";
      action = ":Neotest summary<CR>";
      options = {
        desc = "Neotest Summary toggle";
        silent = true;
      };
    }
  ];
}
