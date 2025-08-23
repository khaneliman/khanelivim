{ config, ... }:
{
  plugins = {
    lzn-auto-require.enable = config.khanelivim.loading.strategy == "lazy";
    lz-n.enable = config.khanelivim.loading.strategy == "lazy";
  };
}
