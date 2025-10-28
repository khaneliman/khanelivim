{ lib, ... }:
{
  options.khanelivim.tasks = {
    runner = lib.mkOption {
      type = lib.types.enum [
        "overseer"
        "vs-tasks"
        "none"
      ];
      default = "overseer";
      description = "Task runner plugin to use";
    };
  };
}
