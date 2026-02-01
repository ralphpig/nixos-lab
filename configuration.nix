{
  pkgs,
  ...
}:

let
  cfg = import ./env.nix;
in
{
  _module.args.cfg = cfg;

  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Allow serial login
  boot.kernelParams = [
    "nomodeset" # No GPU. Avoid DRM/TTM kernel failure
    "console=tty0"
    "console=ttyS0,115200n8"
  ];
  services.getty.extraArgs = [
    "--keep-baud"
    "115200"
    "ttyS0"
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00";
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };
  networking = {
    hostName = "nixos-lab";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";
  users = {
    users.root = {
      openssh.authorizedKeys.keys = cfg.root_user.ssh_public_keys;
    };

    users."${cfg.user.name}" = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = cfg.user.ssh_public_keys;
      extraGroups = [
        "wheel"
        "factorio"
        "minecraft"
      ];
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set shiftwidth=2 smarttab
        set expandtab
        set tabstop=8 softtabstop=0
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    wget
    ripgrep
  ];

  # Don't change ever
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Don't change ever
}
