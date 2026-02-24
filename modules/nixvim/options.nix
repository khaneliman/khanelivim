{
  lib,
  config,
  pkgs,
  ...
}:
let
  neovimVersion = pkgs.neovim.version or "0.0";
  hasNeovim012OrNewer = lib.versionAtLeast neovimVersion "0.12";
in
{
  # Note: The basic clipboard setup below is overridden by vim.g.clipboard in globals
  # to add timeout wrappers that prevent wl-copy from freezing Neovim
  clipboard = {
    register = "unnamedplus";
  };

  colorscheme = config.khanelivim.ui.theme;
  colorschemes.catppuccin.enable = config.khanelivim.ui.theme == "catppuccin";
  colorschemes.nord.enable = config.khanelivim.ui.theme == "nord";
  luaLoader.enable = true;

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2

    # Custom toggles for UI features
    disable_autoformat = false;
    spell_enabled = true;
    colorizing_enabled = false;
    first_buffer_opened = false;
    whitespace_character_enabled = false;
  };

  opts = {
    # Performance & Timing
    updatetime = 100; # CursorHold delay; faster completion and git signs
    lazyredraw = false; # Breaks noice plugin
    synmaxcol = 240; # Disable syntax highlighting for long lines
    timeoutlen = 500; # Key sequence timeout (ms)
    smoothscroll = true; # Smooth scrolling with Ctrl-D/U

    # Project-local config
    exrc = true; # Enable .nvim.lua, .nvimrc, .exrc in project directories

    # UI & Appearance
    number = true;
    relativenumber = true;
    cursorline = true;
    cursorcolumn = false;
    signcolumn = "yes";
    colorcolumn = "100";
    laststatus = 3; # Global statusline
    showtabline = 2;
    showmode = false;
    showmatch = true;
    matchtime = 1; # Flash duration in deciseconds
    termguicolors = true;
    winborder = "rounded";

    # Windows & Splits
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";

    # Mouse
    mouse = "a";
    mousemodel = "extend"; # Right-click extends selection

    # Search
    incsearch = true;
    ignorecase = true; # Case-insensitive search
    smartcase = true; # Unless pattern contains uppercase
    iskeyword = "@,48-57,_,192-255,-"; # Treat dash-separated text as a single word

    # Files & Buffers
    swapfile = false;
    undofile = true;
    autoread = true;
    writebackup = false;
    fileencoding = "utf-8";
    modeline = true; # Scan for editor directives like 'vim: set ft=nix:'
    modelines = 100; # Scan first/last 100 lines for modelines

    # Spelling
    spell = true;
    spelllang = lib.mkDefault [ "en_us" ];

    # Indentation & Formatting
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    breakindent = true;
    copyindent = true;
    preserveindent = true;
    formatoptions = "rqnl1j";
    formatlistpat = "^\\s*[0-9\\-\\+\\*]\\+[\\.)]*\\s\\+";
    linebreak = true;
    wrap = false;

    # Folding
    foldlevel = 10; # Keep most folds open, but preserve structure
    foldcolumn = "1";
    foldenable = true;
    foldmethod = "indent";
    foldnestmax = 10;
    foldlevelstart = -1; # -1 uses foldlevel value
    # foldtext = ""; # Empty uses builtin foldtext
    fillchars = {
      horiz = "━";
      horizup = "┻";
      horizdown = "┳";
      vert = "┃";
      vertleft = "┫";
      vertright = "┣";
      verthoriz = "╋";

      eob = " ";
      diff = "╱";

      fold = " ";
      foldopen = "";
      foldclose = "";

      msgsep = "‾";
    };

    # Completion & Popup
    pumheight = 10; # Max popup menu items
    infercase = true;
    completeopt = [
      "menu"
      "menuone"
      "noselect"
    ]
    ++ lib.optionals (config.khanelivim.completion.tool != "blink") [
      "popup"
    ]; # Native completion options

    # Command Line & Messages
    cmdheight = 0; # Hide command line when not in use
    history = 100; # Command history limit
    report = 9001; # Disable "x more/fewer lines" messages

    # Editor Behavior
    virtualedit = "block";
    startofline = true;
    title = true;
  }
  // lib.optionalAttrs hasNeovim012OrNewer {
    # Use 0.12+/nightly popup capabilities when available.
    completeitemalign = "abbr,kind,menu";
    # completepopup = "height:12,width:60,border:single";
    jumpoptions = "stack";
    pumborder = "single";
    pummaxwidth = 100;
    completetimeout = 100;
  };
}
