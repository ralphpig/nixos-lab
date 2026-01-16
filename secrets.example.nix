# `routes` are used for pihole + traefik routing (w/ https)
#   pihole holds the DNS for the routes
#   traefik w/ cloudflare gets certs for those routes, and routes them
{
  nas = {
    ip = "<ip of nas>";
    a = "<DNS for nas>"; # A record for NAS
    route = "<route for truenas>"; # Traefik route for NAS management
  };

  lab = {
    ip = "<ip of lab>";
    a = "hub.ralphpig.dev";
    route = "<route for hub>";
  };

  unifi = {
    ip = "<ip of unifi / router>";
    route = "<route for unifi>";
  };

  traefik = {
    route = "<route for traefik>";
  };

  home_assistant = {
    route = "<route for home>";
  };

  pihole = {
    route = "<route for pihole>";
    # SHA256 hash of the web UI password (pihole.toml webserver.api.pwhash)
    # I don't know how to generate this. I grabbed it from an old pihole
    web_pwhash = "...";
  };

  # Dynamic DNS
  ddns = {
    route = "lab.example.com";
  };

  # For ACME DNS Challenge
  cloudflare = {
    email = "...";
    api_token = "...";
  };
}
