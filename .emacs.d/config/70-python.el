;;
;;python coding
(use-package python
  :straight nil
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq indent-tabs-mode nil
        indent-level 2
        ;; python-indent-offset 2
        python-indent 2
        tab-width 2
        ;; (define-key (current-local-map) "\C-h" 'python-backspace)
        )
  )

;;
;;company-jedi
(use-package epc
  :after (jedi-core)
  )

(use-package jedi-core
  :after (python)
  :config
  (setq jedi:complete-on-dot t)
  (setq jedi:use-shortcuts t)
  (add-to-list 'company-backends 'company-jedi) ; backendに追加
  :hook (python-mode-hook . jedi:setup)
  :config
  ;; PYTHONPATH上のソースコードがauto-completeの補完対象になる ;;;;;
  (setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
  (setenv "PYTHONPATH" "/usr/local/lib/python3.5/dist-packages")
  (setenv "PYTHONPATH" "~/.local/lib/python2.7/site-packages")
  (setenv "PYTHONPATH" "~/.local/lib/python3.5/site-packages")
  )

;;
;;py-autopep8
(use-package py-autopep8
  :ensure t
  :after (python)
  :config
  (setq py-autopep8-options '("--max-line-length=200"))
  (setq flycheck-flake8-maximum-line-length 200)
  :hook (python-mode-hook . py-autopep8-enable-on-save)
  :bind (:map python-mode-map
              ("C-c C-q" . 'py-autopep8)
              )
  )
