;;; 27-helm-ag.el ---
(use-package helm-ag
  :ensure t
  :after (helm)
  :config
  (setq helm-ag-base-command "rg --vimgrep --no-heading -S")
  (setq helm-ag-command-option nil)

  (setq helm-ag-fuzzy-match t)
  ;;insert thing at point as default search pattern
  (setq helm-ag-thing-at-point ''word)


  :bind ("C-M-g" . helm-ag)
  ;; :bind ("C-M-k" . backward-kill-sexp) ;;recomend
  ;; move to point before jump
  :bind ("C-M-b" . helm-ag-pop-stack)
  )
