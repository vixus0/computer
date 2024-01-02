;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu packages shells)
             (gnu services)
             (guix gexp)
             (gnu home services)
             (gnu home services shells)
	     (ice-9 string-fun)
	     (ice-9 textual-ports))

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
	)))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list 
     (service
       home-fish-service-type
       (home-fish-configuration
         (abbreviations '(("ll" . "ls -l")))))
     (simple-service
       'user-env-vars
       home-environment-variables-service-type
       `(("_GUIX_HOME_RUN" . "yes")))
     (simple-service
       'user-config-files
       home-xdg-configuration-files-service-type
       `(("kitty/kitty.conf" ,(local-file "./kitty.conf"))))
     (simple-service
       'firefox-config-files
       home-files-service-type
       (let ((profile "9ixkawi7.default"))
       `((".mozilla/firefox/profiles.ini" ,(local-file "./firefox/profiles.ini"))
	 (,(string-append ".mozilla/firefox/" profile "/user.js") ,(local-file "./firefox/user.js"))
	 (,(string-append ".mozilla/firefox/" profile "/chrome/userChrome.css") ,(local-file "./firefox/userChrome.css"))))))))
