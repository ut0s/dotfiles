;;; OS

;; ウィンドウ移動 追加設定
(global-set-key [?\C-,] 'windmove-left)
(global-set-key [?\C-.] 'windmove-right)


;; ==========
;; Japanese setting
;; ==========
(set-language-environment "Japanese")
(set-keyboard-coding-system 'japanese-cp932) ;; おまじないかも

;; IME の設定
(setq default-input-method "W32-IME")
(setq-default w32-ime-mode-line-state-indicator "[--]") ;; おこのみで
(setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]")) ;; おこのみで
(w32-ime-initialize)

;; IME ON/OFF 時にカーソル色を変える。
(setq ime-activate-cursor-color "#00a000")
(setq ime-inactivate-cursor-color "#000000")
(set-cursor-color ime-inactivate-cursor-color)
;; ※input-method-activate-hook, input-method-inactivate-hook じゃない方がいい感じになる。
(add-hook 'w32-ime-on-hook
          (function (lambda ()
                      (set-cursor-color ime-activate-cursor-color))))
(add-hook 'w32-ime-off-hook
          (function (lambda ()
                      (set-cursor-color ime-inactivate-cursor-color))))

;; fonts & window size
(setq default-frame-alist
      (append
       '(
	 (font . "MS pgothic-12") ;; デフォルトフォントセット
	 (width . 90) (height . 40) ;; ウィンドウサイズ
	 )
       default-frame-alist)
      )

