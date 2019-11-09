;;22-ivy-swiper.el
(use-package counsel
  :ensure t
  :config
  (ivy-mode 1)
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 30) 
  (setq ivy-extra-directories nil)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-plus)))
  (setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
  (setq swiper-include-line-number-in-search t) 

  ;; counsel
  :bind (("M-x"     . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-r" . swiper)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-load-library)
         ("<f1> i" . counsel-info-lookup-symbol)
         ("C-c C-r" . ivy-resume)
         ("C-c g" . counsel-git-grep)
         ("C-M-g" . counsel-rg)
;;         ("C-c l" . counsel-locate)
	 )

  :bind (:map counsel-find-file-map
	      ("C-l" . counsel-up-directory)
	      ("C-<backspace>" . backward-delete-char)
	      ("C-DEL" . delete-char)
	      )
  
  ;;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

  ;; ;; migemo + swiper（日本語をローマ字検索できるようになる）
  ;; (require 'avy-migemo)
  ;; (avy-migemo-mode 1)
  ;; (require 'avy-migemo-e.g.swiper)
  )

(use-package recentf
  :ensure t
  :config
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 2000)           
  (setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS"))
  (setq recentf-auto-cleanup 'never)           
  (run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list))))
  :bind (("C-x C-r" . counsel-recentf)
	 )
  )

(use-package recentf-ext
  :straight nil
  :load-path "site-lisp"
  :after (recentf)
  )
