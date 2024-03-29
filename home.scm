;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (guix channels)
  (guix gexp)
  (gnu packages)
  (gnu packages shells)
  (gnu services)
  (gnu home)
  (gnu home services)
  (gnu home services guix)
  (gnu home services shells))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages
    (specifications->packages
      (list
        "firefox"
        "glibc-locales"
        "kitty"
        "ncurses" ;; needed for `clear` command
        "neovim"
        "wl-clipboard"
        )))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list
     (simple-service
       'user-channels
       home-channels-service-type
       (list
         (channel
             (name 'nonguix)
             (url "https://gitlab.com/nonguix/nonguix")
             ;; Enable signature verification:
             (introduction
              (make-channel-introduction
               "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
               (openpgp-fingerprint
                "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))
     (simple-service
       'user-fish
       home-fish-service-type
       (home-fish-extension
         (config `(,(local-file "./fish/config.fish")))
         (abbreviations '(("ll" . "ls -l")))))
     (simple-service
       'user-env-vars
       home-environment-variables-service-type
       `(("_GUIX_HOME_RUN" . "yes")
         ("EDITOR" . "nvim")))
     (simple-service
       'user-config-files
       home-xdg-configuration-files-service-type
       `(("kitty/kitty.conf" ,(local-file "./kitty.conf"))
         ("nvim/init.lua" ,(local-file "./nvim/init.lua"))))
     (simple-service
       'firefox-config-files
       home-files-service-type
       (let ((profile "9ixkawi7.default"))
       `((".mozilla/firefox/profiles.ini" ,(local-file "./firefox/profiles.ini"))
         (,(string-append ".mozilla/firefox/" profile "/user.js") ,(local-file "./firefox/user.js"))
         (,(string-append ".mozilla/firefox/" profile "/chrome/userChrome.css") ,(local-file "./firefox/userChrome.css"))))))))
