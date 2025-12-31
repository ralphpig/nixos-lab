{
  secrets ? { },
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
    ];

    settings = {
      webserver.api.pwhash = secrets.pihole.webPasswordHash;
      dns = {
        upstreams = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        hosts = [
          "${secrets.lab.ip} ${secrets.lab.a}"
          "${secrets.nas.ip} ${secrets.nas.a}"
        ];
        cnameRecords = [
          "${secrets.nas.route},${secrets.lab.a}"
          "${secrets.traefik.route},${secrets.lab.a}"
          "${secrets.unifi.route},${secrets.lab.a}"
          "${secrets.pihole.route},${secrets.lab.a}"
          "${secrets.home_assistant.route},${secrets.lab.a}"
        ];
      };
    };
  };

  services.pihole-web = {
    enable = true;
    hostName = secrets.pihole.route;
    ports = [ 9000 ];
  };
}
