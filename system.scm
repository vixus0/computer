;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/Amsterdam")
  (keyboard-layout (keyboard-layout "gb" #:options '("caps:escape")))
  (host-name "spacefoot")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "vixus")
                  (comment "Anshul")
                  (group "users")
                  (home-directory "/home/vixus")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (modify-services
     (append (list (service xfce-desktop-service-type)
		   (service gnome-desktop-service-type)
                   (set-xorg-configuration
                     (xorg-configuration (keyboard-layout keyboard-layout))))

             ;; This is the default list of services we
             ;; are appending to.
             %desktop-services)
     (guix-service-type config => (guix-configuration
       (inherit config)
       (substitute-urls
         (append (list "https://substitutes.nonguix.org")
           %default-substitute-urls))
       (authorized-keys
         (append (list (local-file (string-append (dirname (current-filename)) "/" "nonguix.pub")))
           %default-authorized-guix-keys))))))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "9d59612e-5221-4138-be2b-ad79d3e32f27"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "5C7E-F1AB"
                                       'fat16))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
