(require 'org)
(defvar config-dir (concat user-emacs-directory "config/"))
(org-babel-load-file (expand-file-name "config.org" config-dir))
