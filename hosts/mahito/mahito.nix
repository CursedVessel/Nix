{ config, pkgs, lib, ... }:

{
  # 1. Hostname
  networking.hostName = "mahito";

  # 2. Intel Microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # --- SSH (Required for SOPS keys) ---
  services.openssh = {
    enable = true;
    # Optional security settings
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # --- SOPS SECRETS CONFIG ---
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # This uses your existing SSH key to decrypt the file at boot
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Define the specific secret we want to extract
    secrets.tailscale_key = {};
  };

  # --- TAILSCALE ---
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";

    # Point Tailscale to the decrypted secret path
    authKeyFile = config.sops.secrets.tailscale_key.path;
  };

  # --- FIREWALL ---
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
  };

  # 3. Activation Script
  system.activationScripts.hostNote.text = ''
    echo "Active Host: MAHITO (Intel/Nvidia)"
  '';
}
