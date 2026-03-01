# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# Manually enter dev shell
[group('dev')]
dev:
  nix develop

# Activate the configuration
[group('Main')]
run:
  nix run

# Benchmark key flake eval paths (single tree)
[group('perf')]
eval-bench:
  #!/usr/bin/env bash
  set -euo pipefail
  sys="$(XDG_CACHE_HOME=/tmp nix eval --impure --raw --expr 'builtins.currentSystem')"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#packages.$sys.default.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#nixvimConfigurations.$sys.khanelivim.config.build.package.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false >/dev/null"

# Benchmark current tree against a git ref
[group('perf')]
eval-bench-against ref:
  #!/usr/bin/env bash
  set -euo pipefail
  base_rev="$(git rev-parse {{ref}})"
  base="git+file://$PWD?rev=$base_rev"
  sys="$(XDG_CACHE_HOME=/tmp nix eval --impure --raw --expr 'builtins.currentSystem')"
  echo "Comparing current tree against $base_rev on $sys"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#packages.$sys.default.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false '$base#packages.$sys.default.drvPath' >/dev/null"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#nixvimConfigurations.$sys.khanelivim.config.build.package.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false '$base#nixvimConfigurations.$sys.khanelivim.config.build.package.drvPath' >/dev/null"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false '$base' >/dev/null"
