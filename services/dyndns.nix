{
  pkgs,
  secrets,
  ...
}:
{

  systemd.tmpfiles.rules = [
    "z /etc/nixos/secrets/cloudflare-api-token 0400 root root -"
  ];

  systemd.services.ddclient.serviceConfig = {
    LoadCredential = [
      "cloudflare_token:/etc/nixos/secrets/cloudflare-api-token"
    ];
  };

  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = secrets.cloudflare.zone;
    domains = [ secrets.ddns.route ];
    username = "token";
    passwordFile = "/run/credentials/ddclient.service/cloudflare_token";
    interval = "5min";
  };
}
