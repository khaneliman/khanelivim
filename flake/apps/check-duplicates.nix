_: {
  perSystem =
    { pkgs, lib, ... }:
    {
      apps.check-duplicates = {
        type = "app";
        program = lib.getExe (
          pkgs.writers.writePython3Bin "check-duplicates" { } ''
            import re
            import subprocess
            import sys
            import os
            from pathlib import Path


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


            def build_command_for_profile(profile):
                """Build command for a profile without requiring .#profile attrs"""
                if profile == "default":
                    return "nix build --no-link --print-out-paths .#default"
                expr = (
                    "let f = builtins.getFlake (toString ./.); "
                    "in (f.lib.mkNixvimPackage { "
                    f"system = builtins.currentSystem; profile = \"{profile}\"; "
                    "})"
                )
                return (
                    "nix build --impure --no-link --print-out-paths --expr "
                    f"'{expr}'"
                )


            def main():
                # Check for --path flag
                path_only = "--path" in sys.argv
                if path_only:
                    sys.argv.remove("--path")

                profile = sys.argv[1] if len(sys.argv) > 1 else "default"

                if not path_only:
                    print(f"Building nixvim package for profile: {profile}...")

                try:
                    nixvim_path = run_command(build_command_for_profile(profile))
                except SystemExit:
                    if not path_only:
                        print("Build failed.")
                    return

                if not path_only:
                    print("Extracting pack directory from nvim wrapper...")
                nvim_wrapper = Path(nixvim_path) / "bin" / "nvim"

                if not nvim_wrapper.exists():
                    if not path_only:
                        print(f"Error: nvim wrapper not found at {nvim_wrapper}")
                    sys.exit(1)

                with open(nvim_wrapper, "r") as f:
                    content = f.read()

                match = re.search(r'packpath\^=([^"]*)', content)
                if not match:
                    if not path_only:
                        print("ERROR: Could not find packpath in nvim wrapper")
                    sys.exit(1)

                pack_store_path = match.group(1)
                pack_dir = Path(pack_store_path) / "pack" / "myNeovimPackages"

                if path_only:
                    print(pack_dir)
                    return

                print(f"Pack directory: {pack_dir}")

                start_dir = pack_dir / "start"
                opt_dir = pack_dir / "opt"

                if not start_dir.exists() or not opt_dir.exists():
                    print("Start/Opt directory missing. No duplicates possible.")
                    return

                start_plugins = set(os.listdir(start_dir))
                opt_plugins = set(os.listdir(opt_dir))

                duplicates = start_plugins.intersection(opt_plugins)

                print("\n" + "=" * 50)
                if duplicates:
                    print(
                        f"Found {len(duplicates)} duplicate plugins "
                        f"(in both start/ and opt/):"
                    )
                    print("-" * 50)
                    for plugin in sorted(duplicates):
                        print(f"- {plugin}")
                    print("-" * 50)
                    print("These plugins are likely configured to be lazy-loaded")
                    print("but are being pulled into 'start' by dependencies.")
                else:
                    print("No duplicate plugins found! 🎉")
                print("-" * 50)
                print(f"Location for manual inspection:\n{pack_dir}")
                print("=" * 50 + "\n")


            if __name__ == "__main__":
                main()
          ''
        );
        meta.description = "Identify plugins that exist in both start and opt directories";
      };
    };
}
