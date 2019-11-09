;; init.el

;;
;; package.el
(require 'package)
(setq package-archives '(
                        ("gnu" . "https://elpa.gnu.org/packages/")
                        ("marmalade" . "https://marmalade-repo.org/packages/")
                        ("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;;
;; use-packages

;; ensure to use use-package
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

;; This is only needed once, near the top of the file
(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/elpa/")
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-verbose t)

;;
;; straight.el
;; bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package straight
  :straight nil
  :config
  ;; integration with use-package
  (straight-use-package 'use-package)
  (setq straight-use-package-by-default t)
  )

;;
;; init-loader
(use-package init-loader
  :ensure t
  :config
  (init-loader-load "~/.emacs.d/config/"))

;; このファイルに間違いがあった場合に全てを無効に
(put 'eval-expression 'disabled nil)
