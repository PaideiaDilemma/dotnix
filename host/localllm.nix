{
  config,
  lib,
  ...
}:
# networking configuration
with lib; let
  cfg = config.host;
in {
  options.host.localllm = {
    # Mainly used to disable this config for wsl
    enable = mkOption {
      default = true;
      description = "Whether to enable ollama and stuff";
      type = types.bool;
    };
  };

  config = {
    services.ollama.enable = true;
  # services.open-webui.enable = true;
  };
}
