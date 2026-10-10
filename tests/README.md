# Runtime regression checks

Run these against the built configuration, not a separate init file. From the
repository root, replace `$package` with the output path from the relevant
`mkNixvimConfig` profile build:

```sh
# Basic or standard profile
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/web-tools.lua'
# Minimal or standard profile
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/peek-definition.lua'
# Minimal profile: native spell, diff, fold toggles and save-time whitespace
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/native-mappings.lua'
# Standard profile: Snacks fold toggle and profiler export
CHECK_SNACKS=1 "$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/native-mappings.lua'
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/profiler-json.lua'
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/gitsigns-unstage.lua'
"$package/bin/nvim" --headless -i NONE -n -c 'luafile tests/rustowl-attach.lua'
```

Fixtures go under `XDG_CACHE_HOME`, or the ignored `.planning/` directory when
that variable is unset. The tests exercise installed mappings, commands, and
preview windows. Only the definition request and profiler trace input are
replaced with fixtures; the Neovim preview and JSON export paths remain real.
The RustOwl check uses local stdio fixture servers with Python 3 and delayed
initialization responses; Neovim's LSP attachment and installed plugin remain
real.

Tooling checks use the Python standard library and the development shell's Nix
parser:

```sh
PYTHONDONTWRITEBYTECODE=1 nix develop --command python3 -m unittest discover -s flake/dev -p 'test_*.py'
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s docs/scripts -p 'test_*.py'
```
