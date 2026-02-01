{ ... }:

{
  services.n8n = {
    enable = true;
    openFirewall = true;

    # environment variables that n8n will use.
    environment = {
      # Example: run on default port
      N8N_PORT = "5678";

      # Location for persistent data
      # N8N_USER_FOLDER = "/var/lib/n8n";

      # (optional) enable version notifications
      N8N_VERSION_NOTIFICATIONS_ENABLED = "false";
    };
  };
}
