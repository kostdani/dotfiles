;;(require 'package)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(add-to-list 'load-path "/home/kostdani/.guix-profile/share/emacs/site-lisp")
;;(package-initialize)
;;(guix-emacs-autoload-packages)

(org-babel-load-file "~/dotfiles/Emacs.org")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-pretty-entities t)
 '(package-selected-packages
   '(emojify rainbow-mode frames-only-mode telega all-the-icons-ivy-rich desktop-environment exwm nord-theme geiser doom-modeline company all-the-icons-completion all-the-icons-dired memoize all-the-icons-ibuffer amx doom-themes org-bullets org-superstar org-modern pkg-info projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
