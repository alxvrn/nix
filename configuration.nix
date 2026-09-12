
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.theme = pkgs.catppuccin-grub;
  boot.loader.efi.canTouchEfiVariables = true;  

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Rome";
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
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Rimuovo XTerm
  services.xserver.excludePackages = [pkgs.xterm];
  
  services.flatpak.enable = true;
  
  # List packages installed in system profile. To search, run:   nix search ...
  environment.systemPackages = with pkgs; [
  # Utilità
  git
  flatpak
  bazaar
  fastfetch
  resources
  python3
  # Programmi
  brave
  localsend
  krita
  onlyoffice-desktopeditors
  bottles
  virtualbox
  # Personalizzazione
  bibata-cursors
  tela-icon-theme
  gnome-browser-connector
  gnome-tweaks
  # Estensioni ottime
  gnomeExtensions.dash-to-dock
  gnomeExtensions.dash-to-panel
  gnomeExtensions.user-themes
  gnomeExtensions.clipboard-indicator
  gnomeExtensions.open-bar
  # Estensioni opzionali
  gnomeExtensions.lan-ip-address
  gnomeExtensions.vitals
  ];
  
  # Rimuovi pacchetti gnome inutili
  environment.gnome.excludePackages =  with pkgs; [
  firefox            
  epiphany        
  seahorse	
  yelp		
  gnome-software
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
    settings = {
    
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>Q" ];
      };
      
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/shell" = {      
	 enabled-extensions = [
	 	#"dash-to-panel@jderose9.github.com"
	  	"dash-to-dock@micxgx.gmail.com"
	  	"openbar@neuromorph"
	  	"user-theme@gnome-shell-extensions.gcampax.github.com"
	  ];
      };
         
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        icon-theme = "Tela";
        cursor-theme = "Bibata-Modern-Ice";
        };
      
      };
    }
  ];


  system.stateVersion = "26.05";
}
