_: _final: prev: {
  yarnConfigHook = prev.makeSetupHook {
    name = "yarn-config-hook";
    propagatedBuildInputs = [
      prev.yarn
      prev.fixup-yarn-lock
    ];
    meta = {
      description = "Install nodejs dependencies from an offline yarn cache produced by fetchYarnDeps";
    };
  } ./yarn-config-hook.sh;
}
