;;
;;helm-gtags
(use-package helm-gtags
  :ensure t
  :defer t
  :after (helm)
  :config
  (setq helm-gtags-path-style 'relative ;;root,relative,abusolute
        helm-gtags-ignore-case t ;;Ignore case for searching flag
        helm-gtags-read-only t
        helm-gtags-use-input-at-cursor t ;;Use (when )ord at cursor as input
        helm-gtags-highlight-candidate t ;;Highlighting candidates
        helm-gtags-display-style 'detail ;;Show detail information if this value is 'detail
        helm-gtags-auto-update t
        helm-gtags-update-interval-second 60 ;;default 60
        helm-gtags-pulse-at-cursor t ;;pulse at point after jumping
        helm-gtags-direct-helm-completing t ;;Use helm completion instead of normal Emacs completionxs
        )

  (bind-key (kbd "M-t") 'helm-gtags-find-tag helm-gtags-mode-map) ;;入力されたタグの定義元へジャンプ
  (bind-key (kbd "M-r") 'helm-gtags-find-rtag helm-gtags-mode-map) ;;入力タグを参照する場所へジャンプ
  (bind-key (kbd "C-t") 'helm-gtags-pop-stack helm-gtags-mode-map) ;;ジャンプ前の場所に戻る
  (bind-key (kbd "M-s") 'helm-gtags-find-symbol helm-gtags-mode-map) ;;入力したシンボルを参照する場所へジャンプ
  (bind-key (kbd "M-l") 'helm-gtags-select helm-gtags-mode-map) ;;タグ一覧からタグを選択し, その定義元にジャンプする
  (bind-key (kbd "M-,") 'helm-gtags-previous-history helm-gtags-mode-map)
  (bind-key (kbd "M-.") 'helm-gtags-next-history helm-gtags-mode-map)

  :hook (c-mode-hook . helm-gtags-mode)
  :hook (c++-mode-hook . helm-gtags-mode)
  :hook (python-mode-hook . helm-gtags-mode)
  :hook (asm-mode-hook . helm-gtags-mode)
  :hook (Emacs-Lisp-mode-hook . helm-gtags-mode)
  )
