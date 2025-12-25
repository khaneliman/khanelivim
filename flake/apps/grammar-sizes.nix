_: {
  perSystem =
    { pkgs, lib, ... }:
    {
      apps.check-grammar-sizes = {
        type = "app";
        program = lib.getExe (
          pkgs.writers.writePython3Bin "check-grammar-sizes" { } ''
            import re
            import subprocess
            import sys
            from pathlib import Path


            def human_bytes(size):
                """Convert bytes to human readable format"""
                for unit in ['B', 'KB', 'MB', 'GB']:
                    if size < 1024:
                        return f"{size:.1f}{unit}"
                    size /= 1024
                return f"{size:.1f}TB"


            def run_command(cmd):
                """Run command and return output"""
                try:
                    result = subprocess.run(
                        cmd, shell=True, capture_output=True, text=True, check=True
                    )
                    return result.stdout.strip()
                except subprocess.CalledProcessError as e:
                    print(f"Error running command: {cmd}")
                    print(f"Error: {e.stderr}")
                    sys.exit(1)


            def main():
                profile = sys.argv[1] if len(sys.argv) > 1 else "default"
                print(f"Building nixvim package for profile: {profile}...")
                nixvim_path = run_command(
                    f"nix build --no-link --print-out-paths .#{profile}"
                )

                print("Extracting pack directory from nvim wrapper...")
                nvim_wrapper = Path(nixvim_path) / "bin" / "nvim"

                with open(nvim_wrapper, 'r') as f:
                    content = f.read()

                match = re.search(r'packpath\^=([^"]*)', content)
                if not match:
                    print("ERROR: Could not find packpath in nvim wrapper")
                    sys.exit(1)

                pack_store_path = match.group(1)
                pack_dir = (
                    Path(pack_store_path) / "pack" / "myNeovimPackages" / "start"
                )

                print(f"Pack directory: {pack_dir}")

                if not pack_dir.exists():
                    print(f"ERROR: Pack directory not found at: {pack_dir}")
                    sys.exit(1)

                grammar_paths = list(pack_dir.glob("*grammar*"))
                print(f"Found {len(grammar_paths)} grammar packages")

                if not grammar_paths:
                    print("No grammar packages found")
                    sys.exit(1)

                # Get sizes for all grammars
                grammar_data = []
                for grammar_path in grammar_paths:
                    if grammar_path.is_symlink():
                        target = grammar_path.readlink()
                        try:
                            size_output = run_command(f"nix path-info -S {target}")
                            size = int(size_output.split()[1])
                            name = grammar_path.name.replace(
                                "vimplugin-treesitter-grammar-", ""
                            )
                            grammar_data.append((name, size))
                        except (
                            subprocess.CalledProcessError,
                            ValueError,
                            IndexError,
                        ):
                            continue

                if not grammar_data:
                    print("No grammar size data found")
                    sys.exit(1)

                # Find baseline (minimum size)
                min_size = min(size for _, size in grammar_data)

                print(
                    f"Grammar overhead sizes "
                    f"(base ~{human_bytes(min_size)} subtracted):"
                )
                print("=" * 78)

                # Sort by overhead descending
                grammar_data.sort(key=lambda x: x[1] - min_size, reverse=True)

                for name, size in grammar_data:
                    overhead = size - min_size
                    if overhead > 0:
                        print(
                            f"{name:<20} {human_bytes(overhead):>8} "
                            f"(total: {human_bytes(size)})"
                        )
                    else:
                        print(f"{name:<20} {'0B':>8} (baseline)")


            if __name__ == "__main__":
                main()
          ''
        );
        meta.description = "Check and analyze tree-sitter grammar package sizes";
      };
    };
}
