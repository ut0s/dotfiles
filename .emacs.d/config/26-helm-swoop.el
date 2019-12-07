;;
;;helm-swoop
(use-package helm-swoop
  :ensure t
  :after (helm)
  :bind (("C-r" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-c C-a" . helm-multi-swoop-all)
         )

  ;; When doing isearch, hand the word over to helm-swoop
  ;; (bind-key "C-x C-i" 'helm-swoop-from-isearch isearch-mode-map)
  ;; From helm-swoop to helm-multi-swoop-all
  ;; (bind-key "M-i" 'helm-multi-swoop-all-from-helm-swoop helm-swoop-map)

  ;; Move up and down like isearch
  ;; (bind-key "C-r" 'helm-previous-line helm-swoop-map)
  ;; (bind-key "C-s" 'helm-next-line helm-swoop-map)
  ;; (bind-key "C-r" 'helm-previous-line helm-multi-swoop-map)
  ;; (bind-key "C-s" 'helm-next-line helm-multi-swoop-map)

  :config
  ;; Save buffer when helm-multi-swoop-edit complete
  (setq helm-multi-swoop-edit-save t)
  ;; If this value is t, split window inside the current window
  (setq helm-swoop-split-with-multiple-windows nil)
  ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
  (setq helm-swoop-split-direction 'split-window-vertically)
  ;; If nil, you can slightly boost invoke speed in exchange for text color
  (setq helm-swoop-speed-or-color nil)
  ;; ;; Go to the opposite side of line from the end or beginning of line
  (setq helm-swoop-move-to-line-cycle t)
  ;; Optional face for line numbers
  ;; Face name is `helm-swoop-line-number-face`
  (setq helm-swoop-use-line-number-face t)
  ;; If you prefer fuzzy matching
  (setq helm-swoop-use-fuzzy-match t)

  ;; Disable Use search query at the cursor
  ;; If there is no symbol at the cursor, use the last used words instead.
  (setq helm-swoop-pattern nil)
  (setq helm-swoop-pre-input-function
        (lambda ()
          (let ((pre-query (thing-at-point 'symbol)))
            (if (eq (length helm-swoop-pattern) 0)
                helm-swoop-pattern ;; this variable keeps the last used words
              ""))))
  )
