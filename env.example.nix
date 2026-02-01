# `routes` are used for pihole + traefik routing (w/ https)
#   pihole holds the DNS for the routes
#   traefik w/ cloudflare gets certs for those routes, and routes them
{
  nas = {
    ip = "<ip of nas>";
    a = "<DNS for nas>"; # A record for NAS
    route = "truenas.home.lab"; # Traefik route for NAS management
  };

  lab = {
    ip = "<ip of lab>";
    a = "hub.ralphpig.dev";
    route = "hub.home.lab";
  };

  unifi = {
    ip = "<ip of unifi / router>";
    route = "unifi.home.lab";
  };

  traefik = {
    route = "traefik.home.lab";
  };

  home_assistant = {
    route = "home.home.lab";
  };

  pihole = {
    route = "pihole.home.lab";
    # SHA256 hash of the web UI password (pihole.toml webserver.api.pwhash)
    # I don't know how to generate this. I grabbed it from an old pihole
    web_pwhash = "...";
  };

  n8n = {
    route = "n8n.home.lab";
  };

  cloud_proxy = {
    ip = "10.0.0.2"; # wg interface ip to the proxy, or WAN
    a = "proxy.home.lab";
  };

  # Dynamic DNS
  ddns = {
    route = "lab.example.com";
  };

  # For ACME DNS Challenge
  cloudflare = {
    email = "...";
    # TODO: replace with credential files
    api_token = "...";
  };

  root_user = {
    ssh_public_keys = [
      "ssh-ed25519 ..."
    ];
  };

  user = {
    name = "ralphpig";
    ssh_public_keys = [
      "ssh-ed25519 ..."
    ];
  };
}
