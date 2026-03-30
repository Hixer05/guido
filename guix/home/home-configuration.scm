;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services shells))

(home-environment
 ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
 (packages (specifications->packages (list "emacs"
				      "emacs-doom-themes"
                                      "emacs-doom-modeline"
                                      "emacs-evil"
                                      "emacs-evil-collection"
				      "emacs-vertico"
				      "emacs-corfu"
				      "emacs-marginalia"
				      "emacs-orderless"
				      "emacs-magit"
                                      "guile"
                                      "emacs-geiser"
                                      "emacs-geiser-guile"
                                      "emacs-guix"
				      "emacs-all-the-icons"
				      "font-nerd-symbols"
				      "font-fira-code"
				      "emacs-exwm"
				      "emacs-desktop-environment"
				      "emacs-helpful"
				      "emacs-general"
				      "librewolf"
				      "git"
				      )))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (append (list (service home-bash-service-type
                          (home-bash-configuration
                           (bash-profile (list (local-file
                                                "/home/william/.config/guix/home//.bash_profile"
                                                "bash_profile"))))))
           %base-home-services)))
