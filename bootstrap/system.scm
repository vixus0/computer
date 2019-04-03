(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules tmux)

(define bios-bootloader (bootloader-configuration
                          (bootloader grub-bootloader)
                          (target "/dev/sda1")))

(define efi-bootloader (bootloader-configuration
                         (bootloader grub-efi-bootloader)
                         (target "/boot/efi")))

(operating-system
  (host-name "porcupine")
  (timezone "Europe/London")
  (locale "en_GB.utf8")

  ;; Choose between EFI and BIOS bootloader
  (bootloader (if (access? "/sys/firmware/efi" R_OK) efi-bootloader bios-bootloader))

  ;; LUKS device mapping
  (mapped-devices
   (list (mapped-device
          (source "/dev/sda2")
          (target "root")
          (type luks-device-mapping))))

  ;; Mount root
  (file-systems (cons (file-system
                        (device (file-system-label "root"))
                        (mount-point "/")
                        (type "ext4")
                        (dependencies mapped-devices))
                      %base-file-systems))

  ;; Users
  (users (cons (user-account
                (name "vixus")
                (comment "Anshul Sirur")
                (group "users")
                (supplementary-groups '("wheel" "audio" "video"))
                (home-directory "/home/vixus"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons tmux %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (service dhcp-client-service-type)
                   (service openssh-service-type
                            (openssh-configuration
                              (port-number 2222)))
                   %base-services)))
