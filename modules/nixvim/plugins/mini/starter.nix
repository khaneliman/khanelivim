{ config, lib, ... }:
{
  plugins = {
    mini-starter = {
      enable = true;
      settings = {
        # TODO: compare against persistence
        # sessions = { };
        header = ''
          ██╗  ██╗██╗  ██╗ █████╗ ███╗   ██║███████╗██║     ██║██╗   ██║██║████╗ ████║
          ██║ ██╔╝██║  ██║██╔══██╗████╗  ██║██╔════╝██║     ██║██║   ██║██║████╗ ████║
          █████╔╝ ███████║███████║██╔██╗ ██║█████╗  ██║     ██║██║   ██║██║██╔████╔██║
          ██╔═██╗ ██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║     ██║╚██╗ ██╔╝██║██║╚██╔╝██║
          ██║  ██╗██║  ██║██║  ██║██║ ╚████║███████╗███████╗██║ ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        '';

        evaluate_single = true;

        items = {
          "__unkeyed-1.builtin_actions".__raw = "require('mini.starter').sections.builtin_actions()";
          "__unkeyed-2.recent_files_current_directory".__raw =
            "require('mini.starter').sections.recent_files(10, true)";
          "__unkeyed-3.recent_files".__raw = "require('mini.starter').sections.recent_files(10, false)";
          "__unkeyed-4.sessions".__raw = lib.mkIf (
            config.plugins.mini.enable && lib.hasAttr "sessions" config.plugins.mini.modules
          ) "require('mini.starter').sections.sessions(5, true)";
          __unkeyed-5 = lib.mkIf config.plugins.persistence.enable {
            name = "Restore session";
            action.__raw = "[[lua require('persistence').load()]]";
            section = "Session";
          };
        };

        content_hooks = {
          "__unkeyed-1.adding_bullet".__raw = "require('mini.starter').gen_hook.adding_bullet()";
          "__unkeyed-2.indexing".__raw =
            "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
          "__unkeyed-3.padding".__raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
        };
      };
    };
  };
}
