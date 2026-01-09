{
  secrets ? { },
  ...
}:

{
  users = {
    users.factorio = {
      isSystemUser = true;
      uid = 2001; # svc_factorio
      group = "factorio";
    };

    groups.factorio = {
      gid = 2001; # svc_factorio
    };
  };

  fileSystems."/var/lib/factorio" = {
    device = "${secrets.nas.ip}:/mnt/core/game/factorio";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "nolock"
      "soft"
      "rw"
    ];
  };

  services.factorio = {
    enable = true;
    stateDirName = "factorio"; # dir in /var/lib; this is the default
    openFirewall = true;
  };
}
