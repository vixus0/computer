(use-modules (guix ci))

(cons*
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix"))
  %default-channels)
