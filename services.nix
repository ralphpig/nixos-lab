{
  ...
}:

let
  secrets = if builtins.pathExists ./secrets.nix then import ./secrets.nix else { };
in
{
  imports = [
    ./services/traefik.nix
    # ./services/home-assistant.nix
    ./services/pihole.nix
    ./services/factorio.nix
  ];

  _module.args.secrets = secrets;

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  # If I need docker
  # virtualisation.podman.enable = true;
  # virtualisation.podman.dockerSocket.enable = true;
  # virtualisation.oci-containers.backend = "podman";
}
