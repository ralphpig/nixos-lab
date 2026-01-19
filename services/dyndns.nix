{
  cfg,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "z /etc/credentials/cloudflare-api-token 0400 root root -"
  ];

  systemd.services.ddclient.serviceConfig = {
    LoadCredential = [
      "cloudflare_token:/etc/credentials/cloudflare-api-token"
    ];
  };

  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = cfg.cloudflare.zone;
    domains = [ cfg.ddns.route ];
    username = "token";
    passwordFile = "/run/credentials/ddclient.service/cloudflare_token";
    interval = "5min";
  };
}
