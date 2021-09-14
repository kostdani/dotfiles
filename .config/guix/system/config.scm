;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) (gnu system nss)
(gnu services virtualization) 
(nongnu packages linux)
(nongnu system linux-initrd)
;;(nongnu packages nvidia)
(gnu services linux)
)
(use-service-modules desktop xorg)
(use-package-modules certs gnome emacs emacs-xyz)

(operating-system

  (kernel linux-lts)
  ;; Blacklist conflicting kernel modules.
  (kernel-arguments '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma"))
  (kernel-loadable-modules (list broadcom-sta))
(initrd microcode-initrd)
(firmware (list linux-firmware))

  (host-name "mi")
  (timezone "Europe/Prague")
;;  (locale "en_US.utf8")

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))


(swap-devices (list (uuid "fffae6b2-c610-42b2-9252-6132723b5432")))

  (file-systems (append
                 (list (file-system
                         (device (uuid "409bb307-8eb6-4604-a5c4-a1182d3a3938"))
                         (mount-point "/")
                         (type "ext4"))
			(file-system
                         (device (uuid "4f495343-eca4-400b-9627-9713f10eb010"))
                         (mount-point "/home")
                         (type "ext4"))
                       (file-system
                         (device (uuid "3372-71CA" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  ;; Create user `bob' with `alice' as its initial password.
  (users (cons (user-account
                (name "kostdani")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "libvirt"
                                        "audio" "video")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
			emacs emacs-exwm emacs-desktop-environment
                     ;; for HTTPS access
                     nss-certs
                     ;; for user mounts
                     gvfs)
                    %base-packages))

  ;; Add GNOME and Xfce---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (list (service gnome-desktop-service-type)
(service libvirt-service-type
         (libvirt-configuration
          (unix-sock-group "libvirt")
          (tls-port "16555")))

                          (set-xorg-configuration
                           (xorg-configuration


 ;;(modules (cons* nvidia-driver %default-xorg-modules))
 ;;(drivers '("nvidia"))
                            (keyboard-layout keyboard-layout))))
                    %desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
