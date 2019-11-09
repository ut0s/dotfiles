;;
;;anzu
(use-package anzu
  :ensure t
  :config
  (global-anzu-mode +1)
  )

;;
;;smartparens
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  ;;(sp-pair "<" ">")
  )

;;
;;exec-path-from-shell
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :config
;;   (exec-path-from-shell-initialize)
;;   )

;;
;;expand-region
(use-package expand-region
  :ensure t
  :config
  ;; 真っ先に入れておかないとすぐに括弧に対応してくれない…
  (push 'er/mark-outside-pairs er/try-expand-list)
  :bind ("C-=" . er/expand-region)
  )

;;
;;highlight-symbol
(use-package highlight-symbol
  :ensure t
  :defer t
  :bind ( ("C-<f3>" . highlight-symbol)
          ("<f3>" . highlight-symbol-next)
          ("S-<f3>" . highlight-symbol-prev)
          ("M-<f3>" . highlight-symbol-query-replace)
          )
  :config
  (highlight-symbol-mode  t)
  (setq highlight-symbol-idle-delay 0.5)

  :hook (Flycheck-mode-hook . highlight-symbol-mode)
  ;;自動ハイライト
  :hook (highlight-indentation-mode-hook . highlight-symbol-mode)
  ;;ソースコードにおいてM-p/M-nでシンボル間を移動
  :hook (highlight-symbol-mode-hook . highlight-symbol-nav-mode)
  )

;;
;;point-undo.el
(use-package point-undo
  :straight nil
  :load-path "site-lisp"
  :config
  (bind-key* "<f7>" 'point-undo)
  (bind-key* "C-<f7>" 'point-redo)
  )
