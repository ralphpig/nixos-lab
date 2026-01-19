{
  lib,
  pkgs,
  config,
  cfg,
  ...
}:

let
  mod-list-json = pkgs.writeText "mod-list.json" (
    builtins.toJSON {
      mods = [
        {
          name = "base";
          enabled = true;
        }
        {
          name = "elevated-rails";
          enabled = true;
        }
        {
          name = "quality";
          enabled = true;
        }
        {
          name = "space-age";
          enabled = true;
        }
      ];
    }
  );
in
{
  users = {
    users.factorio = {
      isSystemUser = true;
      uid = 2002; # svc_factorio
      group = "factorio";
    };

    groups.factorio = {
      gid = 2002; # svc_factorio
    };
  };
  systemd.services.factorio = {
    # No other way currently to configure mod-list.json
    postStart = ''
      cat ${mod-list-json} > /var/lib/${config.services.factorio.stateDirName}/mods/mod-list.json
    '';

    serviceConfig = {
      User = "factorio";
      Group = "factorio";
      DynamicUser = lib.mkForce false;

      #####
      #
      # All of this is get fix permission with the NFS mounted state dir
      #
      #####

      # Disable the automated "special" directory setup.
      StateDirectory = lib.mkForce "";

      # 2. Point the service to your NFS mount manually
      WorkingDirectory = "/var/lib/factorio";

      # 3. Relax sandboxing that conflicts with NFS namespaces
      # ProtectSystem = "full";
      # PrivateTmp = false;
      ReadWritePaths = [ "/var/lib/factorio" ];
    };
  };

  fileSystems."/var/lib/factorio" = {
    device = "${cfg.nas.ip}:/mnt/core/game/factorio";
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

    # Game Config
    extraSettingsFile = "/var/lib/factorio/config/server-settings.json";

    saveName = "space-age-2026";
    game-name = "Piggy Wiggy";
    description = "wig that pig";
    admins = [
      "ralphpig"
    ];

    public = false;
    lan = true;
  };
}
