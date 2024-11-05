{ nixified-ai, ... }:

{
  # Add the NVIDIA-compatible packages from nixified-ai to your environment
  environment.systemPackages = [
    nixified-ai.packages.x86_64-linux.textgen-nvidia
    nixified-ai.packages.x86_64-linux.invokeai-nvidia
  ];
}

