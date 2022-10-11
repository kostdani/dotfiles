(use-modules (gnu) (gnu system nss) (guix utils) (nongnu packages linux) (nongnu system linux-initrd) )
(use-service-modules desktop sddm xorg nix virtualization)
(use-package-modules certs gnome emacs emacs-xyz shells wm package-management virtualization)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (host-name "mi-notebook")
  (timezone "Europe/Prague")
  (locale "en_US.utf8")

  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))


  (file-systems (append
                 (list (file-system
                         (device (uuid "4fc04d5b-d72a-48bc-8f1a-82f583e8a2d6"))
                         (mount-point "/")
                         (type "btrfs"))
                       (file-system
                         (device (uuid "6097-8FAB" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (swap-devices (list (swap-space
                       (target (uuid "982e2be1-0876-4d71-bfe4-1ebd63b449e9")))))

  (users (cons (user-account
                (name "kostdani")
                (password (crypt "1415" "$6$abc"))
  (shell (file-append zsh "/bin/zsh"))               
(group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  (packages (append (list
			;;https
		     qemu
                     ;;nix
                     nss-certs
                     emacs emacs-exwm emacs-desktop-environment
                     gvfs
		     sway)
                    %base-packages))




  (services 
   (append (list 
		 ;;(service gnome-desktop-service-type)
		 (bluetooth-service)
		 ;;(service nix-service-type)
		 (service libvirt-service-type
      		   (libvirt-configuration
        		  (unix-sock-group "users")
;;  		          (tls-port "16555")
))
(service virtlog-service-type
         (virtlog-configuration
          (max-clients 1000)))

(service qemu-binfmt-service-type
         (qemu-binfmt-configuration
           (platforms (lookup-qemu-platforms "arm" "aarch64"))))

		 (service sddm-service-type
				      (sddm-configuration
				       (display-server "wayland"))))
           (modify-services %desktop-services
			    (delete gdm-service-type)
			    (guix-service-type config => (guix-configuration
							  (inherit config)
							  (substitute-urls
							   (append (list "https://substitutes.nonguix.org")
								   %default-substitute-urls))
							  (authorized-keys
							   (append (list (plain-file "non-guix.pub"
										     "(public-key 
 (ecc 
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
  )
 )"))
								   %default-authorized-guix-keys)))))))

  

  
  (name-service-switch %mdns-host-lookup-nss))
