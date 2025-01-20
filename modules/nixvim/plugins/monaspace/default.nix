{ self, system, ... }:
{
  extraPlugins = [
    self.packages.${system}.monaspace-nvim
  ];
}
