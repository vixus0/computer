(require 'org)
(add-to-list 'org-babel-default-header-args '(:mkdirp . "yes"))
(dolist (file command-line-args-left)
  (org-babel-tangle-file file))
