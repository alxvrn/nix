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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."alex" = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Rimuovo XTerm
  services.xserver.excludePackages = [pkgs.xterm];
  
  # Abilito servizio flatpak
  services.flatpak.enable = true;
  
  # Aggiungo repository flathub
  systemd.services.flatpak-flathub = {
    description = "Aggiunge il repository Flathub a Flatpak";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };
  
  # Installazione automatica del tema Rewaita
  systemd.services.flatpak-rewaita = {
    description = "Installa il tema Rewaita da Flathub (Flatpak)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "flatpak.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.flatpak}/bin/flatpak install -y --system flathub io.github.swordpuffin.rewaita
      '';
      RemainAfterExit = true;
    };
  };


  # List packages installed in system profile. To search, run:   nix search ...
  environment.systemPackages = with pkgs; [
  # Utilità
  fastfetch
  resources
  #btop
  # Programmi
  brave
  localsend
  krita
  onlyoffice-desktopeditors
  # Personalizzazione
  #rewaita #nixos ha versione troppo vecchia
  bibata-cursors
  tela-icon-theme
  gnome-browser-connector
  gnome-tweaks
  # Estensioni
  gnomeExtensions.dash-to-dock
  gnomeExtensions.dash-to-panel
  gnomeExtensions.user-themes
  gnomeExtensions.lan-ip-address
  gnomeExtensions.clipboard-indicator
  gnomeExtensions.vitals
  ];
  
  # Rimuovi pacchetti gnome inutili
  environment.gnome.excludePackages =  with pkgs; [
  firefox               # si pechè tema sballato
  epiphany         	# browser squallido
  seahorse		# gestore password
  yelp			# help
  gnome-system-monitor
  gnome-connections
  gnome-photos
  gnome-tour
  gnome-calculator
  gnome-calendar
  gnome-characters
  gnome-clocks
  gnome-contacts
  gnome-maps
  gnome-music
  gnome-weather
  ];
  
  
  
  programs.dconf.profiles.user.databases = [
  {
    lockAll = false;
    settings = {
      
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/shell" = {      
	 enabled-extensions = [
	 	"dash-to-panel@jderose9.github.com" # ABILITA DASH TO PANEL
	  	#"dash-to-dock@micxgx.gmail.com"  # ABILITA DASH TO DOCK
	  	"user-theme@gnome-shell-extensions.gcampax.github.com"
	  ];
      };
         
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Tela";
        cursor-theme = "Bibata-Modern-Ice";
        shell-theme = "Rewaita";
        };
      
      };
    }
  ];


  system.stateVersion = "26.05";
}
