{
  config,
  lib,
  ...
}:
# networking configuration
let
  cfg = config.dotnix;
in {
  options.dotnix.localllm = {
    # Mainly used to disable this config for wsl
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable ollama and stuff";
      type = lib.types.bool;
    };
  };

  config = {
    services.ollama.enable = cfg.localllm.enable;
    # services.open-webui.enable = true;
  };
}
