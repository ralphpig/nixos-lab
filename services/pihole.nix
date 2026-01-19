{
  cfg,
  ...
}:

{
  users = {
    users.pihole = {
      isSystemUser = true;
      uid = 2001; # svc_pihole
      group = "pihole";
    };

    groups.pihole = {
      gid = 2001; # svc_pihole
    };
  };

  services.pihole-ftl = {
    enable = true;
    user = "pihole";
    group = "pihole";

    openFirewallDNS = true;
    openFirewallWebserver = true;

    lists = [
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
        description = "hagezi multi pro";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt";
        description = "hagezi threat intelligence";
      }
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/nsfw.txt";
        description = "hagezi nsfw";
      }
    ];

    settings = {
      webserver.api.pwhash = cfg.pihole.web_pwhash;
      dns = {
        upstreams = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        hosts = [
          "${cfg.lab.ip} ${cfg.lab.a}"
          "${cfg.nas.ip} ${cfg.nas.a}"
          "${cfg.cloud_proxy.ip} ${cfg.cloud_proxy.a}"
        ];
        cnameRecords = [
          "${cfg.nas.route},${cfg.lab.a}"
          "${cfg.traefik.route},${cfg.lab.a}"
          "${cfg.unifi.route},${cfg.lab.a}"
          "${cfg.pihole.route},${cfg.lab.a}"
          "${cfg.home_assistant.route},${cfg.lab.a}"
        ];
      };
    };
  };

  services.pihole-web = {
    enable = true;
    hostName = cfg.pihole.route;
    ports = [ 9000 ];
  };
}
