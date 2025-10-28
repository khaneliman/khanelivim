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
  };
}
