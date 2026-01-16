{
  pkgs,
  ...
}:

{
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

  services.openssh.enable = true;
  networking = {
    hostName = "nixos-lab";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";
  users = {
    users.ralphpig = {
      isNormalUser = true;
      extraGroups = [ "wheel" "factorio" ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC  = ''
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
