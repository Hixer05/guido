;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Rome")
  (keyboard-layout (keyboard-layout "us" "intl" #:options '("ctrl:swapcaps")))
  (host-name "guido")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "william")
                  (comment "William Brusa")
                  (group "users")
                  (home-directory "/home/william")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "emacs")
                          (specification->package "emacs-exwm")
                          (specification->package
                           "emacs-desktop-environment")) %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (modify-services %desktop-services
			    (guix-service-type config =>
                                (guix-configuration (inherit config)
                                                    (substitute-urls (append (list
                                                                              "https://nonguix-proxy.ditigal.xyz")
                                                                      %default-substitute-urls))
                                                    (authorized-keys (append (list
                                                                              (local-file
                                                                               "./signing-key.pub"))
                                                                      %default-authorized-guix-keys)))))

		    (list
                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                     (service openssh-service-type)
                     (set-xorg-configuration
                      (xorg-configuration (keyboard-layout keyboard-layout))))))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "c91cad53-e709-496e-9944-1aa9bfbeaa65"))
                          (target "cryptroot")
                          (type luks-device-mapping))
                        (mapped-device
                          (source (uuid
                                   "a4c31c62-718c-49fc-87d2-9a7bfc571afc"))
                          (target "crypthome")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "3B87-9FCB"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (mount-point "/home")
                         (device "/dev/mapper/crypthome")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
