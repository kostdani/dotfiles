(use-modules (gnu) (gnu system nss) (guix utils)
	     (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop sddm xorg)
(use-package-modules certs gnome shells wm terminals xdisorg)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 
 
 (host-name "kost-pc")
 (timezone "Europe/Prague")
 (locale "en_US.utf8")
 (keyboard-layout (keyboard-layout "us" "altgr-intl"))
 

 ;; This is where bootloaders are configured.
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))
              (keyboard-layout keyboard-layout)
	      (menu-entries
	       (list
		(menu-entry
		 (label "Manjaro")
		 (device "/dev/sda1")
		 (chain-loader "/EFI/Manjaro/grubx64.efi"))))))
		

	

 ;; This is where file systems are mounted.
 (file-systems (append
                (list (file-system
                       (device "/dev/sda2")
                       (mount-point "/")
                       (options "subvol=@guix")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda2")
                       (mount-point "/home")
                       (options "subvol=@guix-home")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda2")
                       (mount-point "/gnu")
                       (options "subvol=@gnu")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda2")
                       (mount-point "/var/log")
                       (options "subvol=@log")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda2")
                       (mount-point "/var/cache")
                       (options "subvol=@cache")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda2")
                       (mount-point "/data")
                       (options "subvol=@data")
                       (type "btrfs"))
                      (file-system
                       (device "/dev/sda1")
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))

 ;; This is where user accounts are defined.
 (users (cons (user-account
               (name "kostdani")
               (password (crypt "1415" "$6$abc"))
               (group "users")
	       (shell (file-append zsh "/bin/zsh"))               
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video")))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages (append (list
                    nss-certs
                    gvfs
		    alacritty 
		    sway waybar swayidle swaylock wofi)
                   %base-packages))

 ;; This is where i specify system-wide services.
 (services 
  (append (list (service gnome-desktop-service-type)
		(service lxqt-desktop-service-type)
		(service enlightenment-desktop-service-type)
                (set-xorg-configuration
                 (xorg-configuration
                  (keyboard-layout keyboard-layout))))
          (modify-services %desktop-services
			  (guix-service-type config => (guix-configuration
							 (inherit config)
							 (substitute-urls
							  (append (list "https://substitutes.nonguix.org")
								  %default-substitute-urls))
							 (authorized-keys
							  (append (list (local-file "./signing-key.pub"))
								  %default-authorized-guix-keys))))
			   (gdm-service-type config => (gdm-configuration
							(inherit config)
							(wayland? #t))))))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
