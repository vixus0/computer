;; -- system --

(use-modules
  (gnu)
  (nongnu packages linux)
  (nongnu system linux-initrd))

(use-package-modules security-token)
(use-service-modules cups desktop networking ssh xorg security-token)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/Amsterdam")
  (keyboard-layout (keyboard-layout "gb" #:options '("caps:escape")))
  (host-name "spacefoot")

  ;; The list of user accounts ('root' is implicit).
  (users
    (cons*
      (user-account
        (name "vixus")
        (comment "Anshul")
        (group "users")
        (home-directory "/home/vixus")
        (supplementary-groups '("wheel" "netdev" "audio" "video")))
      %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages
    (append
      (specifications->packages
	(list
	  "intel-vaapi-driver"
	  "nss-certs"))
      %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append
     (list
       (service gnome-desktop-service-type)

       ;; for yubikey
       (service pcscd-service-type)
       (udev-rules-service 'yubikey yubikey-personalization)

       ;; set keyboard layout for xorg
       (set-xorg-configuration
         (xorg-configuration (keyboard-layout keyboard-layout))))

     (modify-services
       ;; default set of services
       %desktop-services

       ;; use wayland
       (gdm-service-type
	 config =>
	 (gdm-configuration
	   (inherit config)
	   (wayland? #t)))

       ;; add substitute servers to guix
       (guix-service-type
	 config =>
	 (guix-configuration
           (inherit config)
           (substitute-urls
             (append (list "https://substitutes.nonguix.org")
               %default-substitute-urls))
           (authorized-keys
             (append (list (local-file (string-append (dirname (current-filename)) "/" "nonguix.pub")))
               %default-authorized-guix-keys)))))))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))

  (mapped-devices
    (list
      (mapped-device
        (source (uuid "9d59612e-5221-4138-be2b-ad79d3e32f27"))
        (target "cryptroot")
        (type luks-device-mapping))))

  ;; uuids fetched using `blkid`
  (file-systems
    (cons*
      (file-system
        (mount-point "/boot/efi")
        (device (uuid "5C7E-F1AB" 'fat16))
        (type "vfat"))
      (file-system
        (mount-point "/")
        (device "/dev/mapper/cryptroot")
        (type "ext4")
        (dependencies mapped-devices)) %base-file-systems)))
