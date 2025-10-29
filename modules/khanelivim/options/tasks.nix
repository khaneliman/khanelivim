{ lib, ... }:
{
  options.khanelivim.tasks = {
    tool = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "overseer"
          "vs-tasks"
        ]
      );
      default = "overseer";
      description = "Task runner tool to use";
    };
  };
}
