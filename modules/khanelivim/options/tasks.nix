{ lib, ... }:
{
  options.khanelivim.tasks = {
    runner = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "overseer"
          "vs-tasks"
        ]
      );
      default = "overseer";
      description = "Task runner plugin to use";
    };
  };
}
