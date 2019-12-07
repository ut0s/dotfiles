;;
;;magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :custom-face
  (magit-diff-added ((t (:background "black" :foreground "green"))))
  (magit-diff-added-highlight ((t (:background "black" :foreground "green"))))
  (magit-diff-removed ((t (:background "black" :foreground "red"))))
  (magit-diff-removed-hightlight ((t (:background "black" :foreground "red"))))
  (magit-hash ((t (:background "black" :foreground "green"))))
  )
