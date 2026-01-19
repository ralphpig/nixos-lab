{
  cfg,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
    9090
  ];

  # TODO: use secrets/... file instead of nix module
  systemd.services.traefik.environment = {
    CLOUDFLARE_ZONE_API_TOKEN = cfg.cloudflare.api_token;
    CLOUDFLARE_DNS_API_TOKEN = cfg.cloudflare.api_token;
  };

  # If I need docker
  # systemd.services.traefik.serviceConfig.SupplementaryGroups = [ "podman" ];

  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log.level = "INFO";
      accessLog = { };

      api = {
        dashboard = true;
        insecure = true;
      };
      entryPoints = {
        web.address = ":80";
        websecure.address = ":443";
        traefik.address = ":9090";
      };

      certificatesResolvers = {
        cloudflare.acme = {
          email = cfg.cloudflare.email;
          dnsChallenge = {
            provider = "cloudflare";
            propagation.delayBeforeChecks = 900; # 15 min to ensure propagation
            resolvers = [
              "1.1.1.1:53"
              "1.0.0.1:53"
            ];
          };
        };
      };

      # If I need docker
      # providers = {
      #   docker = {
      #     endpoint = "unix:///run/podman/podman.sock";
      #   };
      # };
    };

    dynamicConfigOptions = {
      http = {
        middlewares.https_redirect = {
          redirectScheme = {
            scheme = "https";
            permanent = true;
          };
        };
        serversTransports.skip_tls_transport = {
          insecureSkipVerify = true;
        };
      };

      # Traefik
      http.routers.traefik = {
        rule = "Host(`${cfg.traefik.route}`)";
        entryPoints = [ "websecure" ];
        service = "api@internal";
        middlewares = [ "https_redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
      };

      # Home Assistant
      http.routers.home_assistant = {
        rule = "Host(`${cfg.home_assistant.route}`)";
        entryPoints = [ "websecure" ];
        service = "home_assistant";
        middlewares = [ "https_redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
      };
      http.services.home_assistant = {
        loadBalancer = {
          servers = [
            { url = "http://127.0.0.1:8123"; }
          ];
        };
      };

      # Pihole
      http.routers.pihole = {
        rule = "Host(`${cfg.pihole.route}`)";
        entryPoints = [ "websecure" ];
        service = "pihole";
        middlewares = [ "https_redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
      };
      http.services.pihole = {
        loadBalancer = {
          servers = [
            { url = "http://127.0.0.1:9000"; }
          ];
        };
      };

      # Truenas Proxy
      http.routers.proxy_truenas = {
        rule = "Host(`${cfg.nas.route}`)";
        service = "proxy_truenas";
        entryPoints = [ "websecure" ];
        middlewares = [ "https_redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
      };
      http.services.proxy_truenas = {
        loadBalancer = {
          servers = [
            { url = "http://${cfg.nas.ip}:81"; }
          ];
        };
      };

      # Unifi Proxy
      http.routers.proxy_unifi = {
        rule = "Host(`${cfg.unifi.route}`)";
        service = "proxy_unifi";
        entryPoints = [ "websecure" ];
        middlewares = [ "https_redirect" ];
        tls = {
          certResolver = "cloudflare";
        };
      };
      http.services.proxy_unifi = {
        loadBalancer = {
          serversTransport = "skip_tls_transport";
          servers = [
            { url = "https://${cfg.unifi.ip}"; }
          ];
        };
      };
    };
  };

}
