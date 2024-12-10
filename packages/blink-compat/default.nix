{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "blink-compat";
  src = inputs.blink-compat;
  version = inputs.blink-compat.shortRev;
}
