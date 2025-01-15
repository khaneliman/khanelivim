{ self, ... }:
{
  imports = self.lib.khanelivim.readAllFiles ./.;
}
