{
  inputs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-copilot";
  src = inputs.blink-copilot;
  version = inputs.blink-copilot.shortRev;
}
