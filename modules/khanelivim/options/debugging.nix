{ lib, ... }:
{
  options.khanelivim.debugging = {
    adapters = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "dap"
          "dap-virtual-text"
          "debugprint"
        ]
      );
      default = [
        "dap"
        "dap-virtual-text"
        "debugprint"
      ];
      description = "Debug adapter plugins (work together)";
    };

    ui = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "dap-ui"
          "dap-view"
        ]
      );
      default = "dap-ui";
      description = "Debug UI plugin (mutually exclusive)";
    };
  };
}
