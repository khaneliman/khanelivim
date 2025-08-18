/**
  This file is used by nixd's expressions to find the current flake

  The `local` attr is the flake the current working directory falls within.
  Found by searching upwards from the current directory, looking for a path
  that contains a `flake.nix` file.
  `local` will be `null` if no local flake is found.

  The `global` attr is the flake evaluated by the `self` argument. This should
  usually be this flake's in-store path.

  ## Usage

  ```nix
  with import ./_nixd-expr.nix { inherit self; }; «expr»
  ```

  ## Debugging

  In the repl, you can import the file and inspect the returned attrs:

  ```
  nix-repl> find = import «flake»/nvim/config/_nixd-expr.nix { self = "«flake»"; }

  nix-repl> find
  {
    global = { ... };
    local = { ... };
    path = "«another_flake»";
    self = "«flake»";
    system = "x86_64-linux";
  }
  ```
*/
{
  self,
  system ? builtins.currentSystem,
}:
let

  # Reimplementation of `lib.lists.dropEnd 1` using builtins
  dropLast =
    list:
    let
      len = builtins.length list;
      dropped = builtins.genList (builtins.elemAt list) (len - 1);
    in
    if list == [ ] || len == 1 then [ ] else dropped;

  # Walk up the directory path, looking for a flake.nix file
  # Called with an absolute filepath
  findFlake =
    dir:
    let
      isPart = part: builtins.isString part && part != "" && part != ".";
      parts = builtins.filter isPart (builtins.split "/+" dir);
    in
    findFlake' parts;

  # Underlying impl of findFlake
  # Called with a list path instead of a string path
  findFlake' =
    parts:
    let
      dir = "/" + builtins.concatStringsSep "/" parts;
      files = builtins.readDir dir;
      isFlake = files."flake.nix" or null == "regular";
      parent = dropLast parts;
    in
    if parts == [ ] then
      null
    else if isFlake then
      dir
    else
      findFlake' parent;

  # Path to the local flake, or null
  path = findFlake (builtins.getEnv "PWD");
in
{
  inherit system self path;

  local = if path == null then null else builtins.getFlake path;
  global = builtins.getFlake self;
}
