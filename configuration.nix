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

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    ripgrep
  ];

  # Don't change ever
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Don't change ever
}
