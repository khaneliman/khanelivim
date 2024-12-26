{
  inputs,
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "blink-emoji";
  src = inputs.blink-emoji;
  version = inputs.blink-emoji.shortRev;
  dependencies = [ pkgs.vimPlugins.blink-cmp ];
}
