# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;

  networking.hostName = "nixps"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "intl";
    # xkbOptions = "caps:ctrl_modified,grp:shifts_toggle";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enables 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
  	enable = true;
    polkitPolicyOwners = [ "fcoury" ];
	};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fcoury = {
    isNormalUser = true;
    description = "Felipe Coury";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      asciiquarium
      zellij
      firefox
      kate
      alacritty
      starship
      discord
      obs-studio
      google-chrome
      tmux
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "fcoury";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    fish
  ];

  # Enables and configures kanata
  services.kanata.enable = true;
  services.kanata.keyboards.default.config = ''
    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lmet lalt           spc            ralt rmet rctl
    )

    (deflayer qwerty
      @gsc   1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab    q    w    e    r    t    y    u    i    o    p    [    ]    \
      @cap   a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft   z    x    c    v    b    n    m    ,    .    /    @rfl
      lctl   lmet lalt           spc            ralt rmet rctl
    )

    (deflayer extended
      @ugv   1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab    q    w    e    r    t    y    u    i    o    p    [    ]    lrld
      caps   a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft   z    x    c    v    b    n    m    ,    .    /    rsft
      lctl   lmet lalt           spc            ralt rmet rctl
    )

    (defalias
      ;; toggles the extended layer
      rfl (layer-while-held extended)
      
      ;; tap for esc, hold for lctrl
      cap (tap-hold 200 200 esc lctl)

      ;; ;; layer-switch for temporary layer-switch
      ;; ext (layer-while-held extended)

      ;; tilde (shift-grave)
      tld S-grv

      ugv (macro (unshift grv))

      ;; gesc
      gsc (fork esc @tld (lsft))
    )

    ;; (deflayer layers
    ;;   _    @qwr -    lrld _    _    _    _    _    _    _    _    _    _
    ;;   _    _    _    _    _    _    _    _    _    _    _    _    _    _
    ;;   _    _    _    _    _    _    _    _    _    _    _    _    _
    ;;   _    _    _    _    _    _    _    _    _    _    _    _
    ;;   _    _    _              _              _    _    _
    ;; )
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Caps is Esc when tapped and Control when held
  # systemd.user.services.xcape = {
  #   description = "Set Caps Lock as Control when held and Escape when tapped";
  #   wantedBy = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.xcape}/bin/xcape -e 'Caps_Lock=Escape'";
  #     Restart = "always";
  #   };
  # };

}
