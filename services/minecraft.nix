{
  cfg,
  config,
  ...
}:

let
  unstable = import <nixpkgs-unstable> {
    config = config.nixpkgs.config;
  };

  dataDir = "/var/lib/minecraft";
in
{
  users = {
    users.minecraft = {
      isSystemUser = true;
      uid = 2003; # svc_minecraft
      group = "minecraft";
    };

    groups.minecraft = {
      gid = 2003; # svc_minecraft
    };
  };

  # systemd.services.minecraft-server.serviceConfig = {
  #   # Avoid user namespaces that break NFS uid/gid mapping.
  #   PrivateUsers = lib.mkForce false;
  # };

  fileSystems."${dataDir}" = {
    device = "${cfg.nas.ip}:/mnt/core/game/minecraft";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "nolock"
      "soft"
      "rw"
    ];
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    package = unstable.minecraft-server;
    dataDir = dataDir;
    openFirewall = true;
  };
}
