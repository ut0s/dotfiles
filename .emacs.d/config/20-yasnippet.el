;;
;;yasnippet
(use-package yasnippet
  :ensure t
  :commands (yas-insert-snippet)
  :init
  ;; yas起動
  (setq yas-snippet-dirs
        '("~/.emacs.d/mysnippets" ;; 自分用のスニペットフォルダ
          "~/.emacs.d/misc/snippets"   ;; ダウンロードしたもの
          "~/.emacs.d/elpa/yasnippet/snippets" ;; 最初から入っていたスニペット(省略可能)
          ))

  ;; 既存スニペットを挿入する
  ;; (bind-key "C-x i" 'yas-insert-snippet yas-minor-mode-map)
  :bind (:map yas-minor-mode-map
              ("C-x i" . yas-insert-snippet)
              )

  )
(yas-global-mode 1)
