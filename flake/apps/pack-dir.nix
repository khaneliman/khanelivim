_: {
  perSystem =
    { pkgs, lib, ... }:
    {
      apps.get-pack-dir = {
        type = "app";
        program = lib.getExe (
          pkgs.writers.writePython3Bin "get-pack-dir" { } ''
            import re
            import subprocess
            import sys
            from pathlib import Path


            def run_command(cmd):
                """Run command and return output"""
                try:
                    result = subprocess.run(
                        cmd, shell=True, capture_output=True, text=True, check=True
                    )
                    return result.stdout.strip()
                except subprocess.CalledProcessError as e:
                    print(f"Error running command: {cmd}", file=sys.stderr)
                    print(f"Error: {e.stderr}", file=sys.stderr)
                    sys.exit(1)


            def main():
                nixvim_path = run_command(
                    "nix build --no-link --print-out-paths .#default"
                )

                nvim_wrapper = Path(nixvim_path) / "bin" / "nvim"

                with open(nvim_wrapper, 'r') as f:
                    content = f.read()

                match = re.search(r'packpath\^=([^"]*)', content)
                if not match:
                    print(
                        "ERROR: Could not find packpath in nvim wrapper",
                        file=sys.stderr
                    )
                    sys.exit(1)

                pack_store_path = match.group(1)
                pack_dir = Path(pack_store_path) / "pack" / "myNeovimPackages"

                print(pack_dir)


            if __name__ == "__main__":
                main()
          ''
        );
      };
    };
}
