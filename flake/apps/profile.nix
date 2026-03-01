_: {
  perSystem =
    {
      pkgs,
      lib,
      profileBuildCommandPython,
      ...
    }:
    {
      apps.profile =
        let
          profiler =
            pkgs.writers.writePython3Bin "profile-nvim"
              {
                libraries = [ pkgs.python3Packages.rich ];
              }
              ''
                import argparse
                import json
                import os
                import subprocess
                import sys
                import tempfile
                from datetime import datetime
                from pathlib import Path

                from rich.console import Console
                from rich.table import Table

                console = Console()
                CACHE_DIR = Path.home() / ".cache" / "khanelivim" / "profiles"


                def get_baseline_file(event, profile="default"):
                    """Get baseline file path for a specific event and profile"""
                    baseline_path = CACHE_DIR / f"baseline-{profile}-{event}.json"
                    # Fallback for default profile to legacy naming without profile
                    if profile == "default" and not baseline_path.exists():
                        legacy_path = CACHE_DIR / f"baseline-{event}.json"
                        if legacy_path.exists():
                            return legacy_path
                    return baseline_path

                ${profileBuildCommandPython}


                def run_command(cmd, env=None):
                    """Run command and return output"""
                    merged_env = os.environ.copy()
                    if env:
                        merged_env.update(env)
                    try:
                        result = subprocess.run(
                            cmd,
                            shell=True,
                            capture_output=True,
                            text=True,
                            check=True,
                            env=merged_env,
                        )
                        return result.stdout.strip()
                    except subprocess.CalledProcessError as e:
                        console.print(f"[red]Error running command:[/red] {cmd}")
                        console.print(f"[red]stderr:[/red] {e.stderr}")
                        return None


                def build_nvim(profile="default", package=None):
                    """Build nixvim and return path to nvim binary"""
                    profile_label = f" ({profile})" if profile != "default" else ""
                    console.print(f"[blue]Building khanelivim{profile_label}...[/blue]")
                    if package:
                        nixvim_path = run_command(
                            f"nix build --no-link --print-out-paths {package}"
                        )
                    else:
                        nixvim_path = run_command(build_command_for_profile(profile))
                    if not nixvim_path:
                        console.print("[red]Failed to build nixvim[/red]")
                        sys.exit(1)
                    return Path(nixvim_path) / "bin" / "nvim", profile


                def run_profile(nvim_bin, output_path, event="ui", interactive=False):
                    """Run a single profiling iteration"""
                    env = {
                        "PROF": "1",
                        "PROF_EVENT": event,
                        "PROF_OUTPUT": str(output_path),
                        "PROF_FORMAT": "json",
                        "PROF_AUTO_QUIT": "1",
                    }

                    merged_env = {**os.environ, **env}

                    if interactive:
                        # Run nvim in terminal - user sees it, auto-quits after profile
                        console.print(
                            "[dim]Starting nvim (will auto-quit after profiling)...[/dim]"
                        )
                        result = subprocess.run(
                            [str(nvim_bin)],
                            env=merged_env,
                        )
                    elif event == "ui":
                        # Headless for VimEnter - fast, no display needed
                        cmd = f"timeout 10 {nvim_bin} --headless"
                        result = subprocess.run(
                            cmd,
                            shell=True,
                            capture_output=True,
                            text=True,
                            env=merged_env,
                        )
                    else:
                        # xvfb for deferred/lazy events that need UIEnter
                        cmd = f"timeout 20 xvfb-run -a {nvim_bin}"
                        result = subprocess.run(
                            cmd,
                            shell=True,
                            capture_output=True,
                            text=True,
                            env=merged_env,
                        )

                    # Check if output file was created
                    if output_path.exists():
                        return True

                    # If headless didn't work, the profiler might not have
                    # triggered Try reading any error
                    if result.returncode != 0:
                        console.print(
                            f"[yellow]Warning: nvim exited with code "
                            f"{result.returncode}[/yellow]"
                        )

                    return output_path.exists()


                def load_profile(path):
                    """Load a profile JSON file"""
                    try:
                        with open(path) as f:
                            return json.load(f)
                    except (json.JSONDecodeError, FileNotFoundError) as e:
                        console.print(f"[red]Failed to load profile {path}: {e}[/red]")
                        return None


                def average_profiles(profiles):
                    """Average multiple profile runs"""
                    if not profiles:
                        return None

                    avg = {
                        "timestamp": datetime.now().isoformat(),
                        "event": profiles[0].get("event", "unknown"),
                        "iterations": len(profiles),
                        "startup_time_ms": 0,
                        "total_trace_time_ms": 0,
                        "trace_count": 0,
                        "by_plugin": {},
                        "traces": [],
                    }

                    # Average startup times
                    startup_times = [
                        p.get("startup_time_ms", 0)
                        for p in profiles
                        if p.get("startup_time_ms")
                    ]
                    if startup_times:
                        avg["startup_time_ms"] = sum(startup_times) / len(startup_times)

                    # Average trace times
                    trace_times = [
                        p.get("total_trace_time_ms", 0) for p in profiles
                    ]
                    avg["total_trace_time_ms"] = sum(trace_times) / len(trace_times)

                    # Average by plugin
                    plugin_data = {}
                    for profile in profiles:
                        for plugin in profile.get("by_plugin", []):
                            name = plugin.get("name", "unknown")
                            if name not in plugin_data:
                                plugin_data[name] = {"times": [], "counts": []}
                            plugin_data[name]["times"].append(
                                plugin.get("time_ms", 0)
                            )
                            plugin_data[name]["counts"].append(
                                plugin.get("count", 0)
                            )

                    avg["by_plugin"] = []
                    for name, data in plugin_data.items():
                        avg["by_plugin"].append({
                            "name": name,
                            "time_ms": sum(data["times"]) / len(data["times"]),
                            "count": int(sum(data["counts"]) / len(data["counts"])),
                        })
                    avg["by_plugin"].sort(key=lambda x: x["time_ms"], reverse=True)

                    # Use traces from first profile (structure is complex to average)
                    if profiles:
                        avg["traces"] = profiles[0].get("traces", [])
                        avg["trace_count"] = profiles[0].get("trace_count", 0)

                    return avg


                def compare_profiles(baseline, current):
                    """Compare two profiles and return diff data"""
                    if not baseline or not current:
                        return None

                    diff = {
                        "baseline_time_ms": baseline.get("startup_time_ms", 0),
                        "current_time_ms": current.get("startup_time_ms", 0),
                        "delta_ms": 0,
                        "delta_percent": 0,
                        "improvements": [],
                        "regressions": [],
                    }

                    base_time = baseline.get("startup_time_ms", 0)
                    curr_time = current.get("startup_time_ms", 0)

                    if base_time > 0:
                        diff["delta_ms"] = curr_time - base_time
                        diff["delta_percent"] = (
                            (curr_time - base_time) / base_time
                        ) * 100

                    # Compare by plugin
                    base_plugins = {
                        p["name"]: p for p in baseline.get("by_plugin", [])
                    }
                    curr_plugins = {
                        p["name"]: p for p in current.get("by_plugin", [])
                    }

                    all_plugins = set(base_plugins.keys()) | set(curr_plugins.keys())

                    for name in all_plugins:
                        base_p = base_plugins.get(name, {"time_ms": 0})
                        curr_p = curr_plugins.get(name, {"time_ms": 0})

                        base_ms = base_p.get("time_ms", 0)
                        curr_ms = curr_p.get("time_ms", 0)
                        delta = curr_ms - base_ms

                        entry = {
                            "name": name,
                            "baseline_ms": base_ms,
                            "current_ms": curr_ms,
                            "delta_ms": delta,
                        }

                        if delta < -0.1:  # Improvement threshold
                            diff["improvements"].append(entry)
                        elif delta > 0.1:  # Regression threshold
                            diff["regressions"].append(entry)

                    # Sort by absolute delta
                    diff["improvements"].sort(key=lambda x: x["delta_ms"])
                    diff["regressions"].sort(
                        key=lambda x: x["delta_ms"], reverse=True
                    )

                    return diff


                def print_profile_summary(profile, title="Profile Summary"):
                    """Print a profile summary using rich tables"""
                    console.print(f"\n[bold blue]=== {title} ===[/bold blue]")

                    if profile.get("startup_time_ms"):
                        console.print(
                            f"Startup time: [green]{profile['startup_time_ms']:.2f}ms"
                            f"[/green]"
                        )
                    console.print(f"Event: {profile.get('event', 'unknown')}")
                    console.print(
                        f"Total trace time: "
                        f"{profile.get('total_trace_time_ms', 0):.2f}ms"
                    )

                    # Plugin table
                    table = Table(title="Top Plugins by Time")
                    table.add_column("Plugin", style="cyan")
                    table.add_column("Time (ms)", justify="right", style="green")
                    table.add_column("Calls", justify="right")

                    for plugin in profile.get("by_plugin", [])[:15]:
                        table.add_row(
                            plugin["name"],
                            f"{plugin['time_ms']:.3f}",
                            str(plugin.get("count", 0)),
                        )

                    console.print(table)


                def print_comparison(diff):
                    """Print comparison results"""
                    console.print("\n[bold blue]=== Profile Comparison ===[/bold blue]")

                    base_ms = diff["baseline_time_ms"]
                    curr_ms = diff["current_time_ms"]
                    delta_ms = diff["delta_ms"]
                    delta_pct = diff["delta_percent"]

                    color = "green" if delta_ms <= 0 else "red"
                    sign = "+" if delta_ms > 0 else ""

                    console.print(f"Baseline: {base_ms:.2f}ms")
                    console.print(f"Current:  {curr_ms:.2f}ms")
                    console.print(
                        f"Delta:    [{color}]{sign}{delta_ms:.2f}ms "
                        f"({sign}{delta_pct:.1f}%)[/{color}]"
                    )

                    if diff["improvements"]:
                        console.print("\n[green]Top Improvements:[/green]")
                        for entry in diff["improvements"][:5]:
                            console.print(
                                f"  {entry['name']}: "
                                f"{entry['baseline_ms']:.2f}ms -> "
                                f"{entry['current_ms']:.2f}ms "
                                f"([green]{entry['delta_ms']:.2f}ms[/green])"
                            )

                    if diff["regressions"]:
                        console.print("\n[red]Top Regressions:[/red]")
                        for entry in diff["regressions"][:5]:
                            console.print(
                                f"  {entry['name']}: "
                                f"{entry['baseline_ms']:.2f}ms -> "
                                f"{entry['current_ms']:.2f}ms "
                                f"([red]+{entry['delta_ms']:.2f}ms[/red])"
                            )


                def main():
                    parser = argparse.ArgumentParser(
                        description="Profile khanelivim startup performance"
                    )
                    parser.add_argument(
                        "--baseline",
                        action="store_true",
                        help="Save current profile as baseline",
                    )
                    parser.add_argument(
                        "--compare",
                        action="store_true",
                        help="Compare against baseline",
                    )
                    parser.add_argument(
                        "--event",
                        choices=["ui", "deferred", "lazy"],
                        default="ui",
                        help="Profiling event (default: ui, uses VimEnter)",
                    )
                    parser.add_argument(
                        "--profile",
                        choices=["default", "minimal", "basic", "standard", "debug"],
                        default="default",
                        help="Profile preset to build and profile (default: default)",
                    )
                    parser.add_argument(
                        "--package",
                        default=None,
                        help="Optional explicit flake package ref to profile. "
                             "Overrides --profile when provided.",
                    )
                    parser.add_argument(
                        "--output",
                        type=Path,
                        help="Output directory for profile data",
                    )
                    parser.add_argument(
                        "--iterations",
                        type=int,
                        default=None,
                        help="Number of profiling iterations "
                             "(default: 10 for baseline, 5 otherwise)",
                    )
                    parser.add_argument(
                        "-i", "--interactive",
                        action="store_true",
                        help="Run nvim interactively in terminal (for accurate profiling)",
                    )
                    args = parser.parse_args()

                    # Set default iterations based on whether we're doing baseline
                    if args.iterations is None:
                        args.iterations = 10 if args.baseline else 5

                    # Ensure cache directory exists
                    CACHE_DIR.mkdir(parents=True, exist_ok=True)
                    runs_dir = CACHE_DIR / "runs"
                    runs_dir.mkdir(exist_ok=True)

                    # Build nvim
                    selected_profile = args.profile
                    if args.package:
                        selected_profile = "default"
                    nvim_bin, profile = build_nvim(
                        profile=selected_profile,
                        package=args.package,
                    )
                    console.print(f"[green]Built:[/green] {nvim_bin}")
                    console.print(f"[blue]Profile:[/blue] {profile}")

                    # Run profiling iterations
                    console.print(
                        f"\n[blue]Running {args.iterations} profiling iterations "
                        f"(event: {args.event})...[/blue]"
                    )

                    profiles = []
                    with tempfile.TemporaryDirectory() as tmpdir:
                        for i in range(args.iterations):
                            output_path = Path(tmpdir) / f"profile_{i}.json"
                            console.print(f"  Iteration {i + 1}...", end=" ")

                            success = run_profile(
                                nvim_bin, output_path,
                                event=args.event,
                                interactive=args.interactive,
                            )

                            if success and output_path.exists():
                                profile_data = load_profile(output_path)
                                if profile_data:
                                    profiles.append(profile_data)
                                    startup = profile_data.get("startup_time_ms", 0)
                                    console.print(f"[green]{startup:.2f}ms[/green]")
                                else:
                                    console.print("[yellow]parse error[/yellow]")
                            else:
                                console.print("[red]failed[/red]")

                    if len(profiles) == 0:
                        console.print(
                            "[red]No successful profiles captured[/red]"
                        )
                        console.print(
                            "[yellow]Note: Profiling requires nvim to run with "
                            "a display. Try running in a terminal with a display "
                            "available, or use --interactive mode.[/yellow]"
                        )
                        sys.exit(1)

                    # Handle single vs multiple iterations
                    if len(profiles) == 1:
                        console.print(
                            "\n[dim]Single iteration - using profile directly[/dim]"
                        )
                        averaged = profiles[0]
                    else:
                        # Discard first run (cache warmup), average the rest
                        console.print(
                            f"\n[dim]Discarding first run, "
                            f"averaging {len(profiles) - 1} runs...[/dim]"
                        )
                        averaged = average_profiles(profiles[1:])

                    # Print summary
                    print_profile_summary(averaged, "Averaged Profile")

                    # Save profile
                    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
                    output_dir = args.output or CACHE_DIR

                    if args.output:
                        output_dir = args.output
                        output_dir.mkdir(parents=True, exist_ok=True)

                    profile_path = output_dir / f"profile-{profile}-{timestamp}.json"
                    with open(profile_path, "w") as f:
                        json.dump(averaged, f, indent=2)
                    console.print(f"\n[green]Profile saved:[/green] {profile_path}")

                    # Handle baseline
                    if args.baseline:
                        baseline_file = get_baseline_file(args.event, profile)
                        with open(baseline_file, "w") as f:
                            json.dump(averaged, f, indent=2)
                        console.print(
                            f"[green]Baseline saved:[/green] {baseline_file}"
                        )

                    # Handle comparison
                    if args.compare:
                        baseline_file = get_baseline_file(args.event, profile)
                        if baseline_file.exists():
                            baseline = load_profile(baseline_file)
                            if baseline:
                                diff = compare_profiles(baseline, averaged)
                                if diff:
                                    print_comparison(diff)

                                    # Save diff
                                    diff_path = (
                                        output_dir / f"diff-{profile}-{timestamp}.json"
                                    )
                                    with open(diff_path, "w") as f:
                                        json.dump(diff, f, indent=2)
                                    console.print(
                                        f"[green]Diff saved:[/green] {diff_path}"
                                    )
                        else:
                            console.print(
                                f"[yellow]No baseline found for profile "
                                f"'{profile}' event '{args.event}'. "
                                f"Run with --baseline --profile {profile} "
                                f"--event {args.event} first.[/yellow]"
                            )


                if __name__ == "__main__":
                    main()
              '';
          wrapped =
            pkgs.runCommand "profile-nvim"
              {
                nativeBuildInputs = [ pkgs.makeWrapper ];
                passthru.meta.mainProgram = "profile-nvim";
              }
              ''
                makeWrapper ${profiler}/bin/profile-nvim $out/bin/profile-nvim \
                  ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
                    --prefix PATH : ${lib.makeBinPath [ pkgs.xvfb-run ]}
                  ''}
              '';
        in
        {
          type = "app";
          program = lib.getExe wrapped;
          meta.description = "Profile khanelivim startup performance";
        };
    };
}
