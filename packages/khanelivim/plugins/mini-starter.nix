{
  plugins = {
    mini = {
      enable = true;

      modules = {
        starter = {
          header = ''
            ██╗  ██╗██╗  ██╗ █████╗ ███╗   ██╗███████╗██╗     ██╗███╗   ██╗██╗██╗  ██╗
            ██║ ██╔╝██║  ██║██╔══██╗████╗  ██║██╔════╝██║     ██║████╗  ██║██║╚██╗██╔╝
            █████╔╝ ███████║███████║██╔██╗ ██║█████╗  ██║     ██║██╔██╗ ██║██║ ╚███╔╝
            ██╔═██╗ ██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║     ██║██║╚██╗██║██║ ██╔██╗
            ██║  ██╗██║  ██║██║  ██║██║ ╚████║███████╗███████╗██║██║ ╚████║██║██╔╝ ██╗
            ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
          '';

          evaluate_single = true;

          items = {
            "__unkeyed.buildtin_actions".__raw = "require('mini.starter').sections.builtin_actions()";
            "__unkeyed.recent_files_current_directory".__raw = "require('mini.starter').sections.recent_files(10, false)";
            "__unkeyed.recent_files".__raw = "require('mini.starter').sections.recent_files(10, true)";
            "__unkeyed.sessions".__raw = "require('mini.starter').sections.sessions(5, true)";
          };

          content_hooks = {
            "__unkeyed.adding_bullet".__raw = "require('mini.starter').gen_hook.adding_bullet()";
            "__unkeyed.indexing".__raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
            "__unkeyed.padding".__raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
          };
        };
      };
    };
  };
}
