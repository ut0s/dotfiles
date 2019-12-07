;;
;;config for cc-mode
(use-package cc-mode
  :straight nil
  :defer t
  :config
  (setq-default c-basic-offset 2
                tab-width 2
                indent-tabs-mode nil)
  )

;;
;;clang-format
(use-package clang-format
  :straight nil
  :defer t
  :load-path "site-lisp"
  :commands (clang-format-buffer)
  :config
  (setq clang-format-style-option "file")
  ;; (bind-key "C-c <down>" 'clang-format-buffer c-mode-base-map)
  :bind (:map c-mode-base-map
              ("C-c <down>" . clang-format-buffer)
              )
  )
