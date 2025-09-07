(require 'org)
(defvar config-dir (concat user-emacs-directory "config/"))
;; Force re-tangle config.el without relying on org-babel-load-file timestamps:
;; emacs -Q --batch --eval "(progn (require 'org) (org-babel-tangle-file \"$HOME/dotfiles/.emacs.d/config/config.org\" \"$HOME/dotfiles/.emacs.d/config/config.el\" \"elisp\"))"
(org-babel-load-file (expand-file-name "config.org" config-dir))
(org-babel-tangle-file (expand-file-name "misc/yasnippet.org" user-emacs-directory))
