{
  config,
  lib,
  ...
}:
let
  # Sample patterns for testing plugin functionality
  samplePatterns = {
    ssn = "\\d{3}-\\d{2}-\\d{4}"; # Matches: 123-45-6789
    email = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"; # Matches: user@example.com
    url = "^(https?://)([\\da-z.-]+)\\.([a-z.]{2,6})([/\\w .-]*)*/?$"; # Matches: https://example.com/path
  };
in
{
  config = {
    plugins.patterns = {
      enable = true;

      lazyLoad.settings.cmd = [ "Patterns" ];

      luaConfig.pre = ''
        -- Sample patterns for testing patterns.nvim plugin:
        -- SSN: ${samplePatterns.ssn}
        -- Email: ${samplePatterns.email}
        -- URL: ${samplePatterns.url}
      '';
    };

    keymaps = lib.mkIf config.plugins.patterns.enable [
      {
        mode = "n";
        key = "<leader>ph";
        action = "<cmd>Patterns hover<CR>";
        options = {
          desc = "Patterns hover";
        };
      }
      {
        mode = "n";
        key = "<leader>pe";
        action = "<cmd>Patterns explain<CR>";
        options = {
          desc = "Patterns explain";
        };
      }
    ];
  };
}
