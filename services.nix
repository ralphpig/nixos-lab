{
  ...
}:

{
  imports = [
    ./services/dyndns.nix
    ./services/traefik.nix
    ./services/n8n.nix
    ./services/pihole.nix
    ./services/factorio.nix
    ./services/minecraft.nix
    ./services/n8n.nix
  ];

  systemd.tmpfiles.rules = [
    "d /etc/credentials 0700 root root -"
  ];

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  # If I need docker
  # virtualisation.podman.enable = true;
  # virtualisation.podman.dockerSocket.enable = true;
  # virtualisation.oci-containers.backend = "podman";
}
