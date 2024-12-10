{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-copilot";
  src = inputs.blink-cmp-copilot;
  version = inputs.blink-cmp-copilot.shortRev;
}
