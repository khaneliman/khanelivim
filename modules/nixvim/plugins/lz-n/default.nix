{ config, ... }:
{
  plugins = {
    # lz.n documentation
    # See: https://github.com/lumen-oss/lz.n
    lzn-auto-require.enable = config.khanelivim.loading.strategy == "lazy";
    lz-n.enable = config.khanelivim.loading.strategy == "lazy";
  };
}
