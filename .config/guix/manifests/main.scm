;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
  (list "openssh"
        "libssh"
        "stow"
        "augustus"
        "openmw"
        "nyxt"
        "tor"
        "hedgewars"
        "gnome-calendar"
        "playonlinux"
        "steam"
        "xkill"
        "wine64"
        "virt-manager"
        "qemu"
        "git"
        "boxes"
        "owncloud-client"
        "xprop"
        "kdeconnect"
        "gparted"
        "gnome-tweaks"
        "ungoogled-chromium"
        "clojure"
        "emacs"
        "pulseaudio"
        "inxi"
        "icecat"
        "xdg-utils"
        "ncurses"
        "guile"
        "alsa-lib"
        "alsa-utils"))
