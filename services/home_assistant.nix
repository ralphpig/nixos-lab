{
  lib,
  cfg,
  ...
}:

let
  configDir = "/var/lib/hass";
in
{
  users.users.hass = {
    isSystemUser = true;
    uid = lib.mkForce 2004;
    group = "hass";
  };

  users.groups.hass = {
    gid = lib.mkForce 2004;
  };

  fileSystems."${configDir}" = {
    device = "${cfg.nas.ip}:/mnt/core/config/home-assistant";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "nolock"
      "soft"
      "rw"
    ];
  };

  services.home-assistant = {
    enable = true;
    configDir = configDir;
    openFirewall = true;

    extraComponents = [
      "isal" # https://www.home-assistant.io/integrations/isal

      "tplink"
    ];

    config = {
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
  };

  systemd.services.home-assistant.serviceConfig = {
    User = lib.mkForce "hass";
    Group = lib.mkForce "hass";
  };
}
