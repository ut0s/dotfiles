;; Time-stamp: <2020-09-06 19:17:58 tagashira>
;; emacs OS依存設定

;; ==========
;; key binding
;; ==========

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
;; (setq default-frame-alist
;;       (append
;;        '(
;; 	 (font . "MS pgothic-12") ;; デフォルトフォントセット
;; 	 (width . 90) (height . 40) ;; ウィンドウサイズ
;; 	 )
;;        default-frame-alist)
;;       )

;; font config
;; GUI
(when window-system
  (progn
    ;; 半角英字設定
    (set-face-attribute 'default nil :family "Consolas" :height 100)

    ;; 全角かな設定
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      (font-spec :family "IPAゴシック" :size 14))
    ;; 半角ｶﾅ設定
    (set-fontset-font (frame-parameter nil 'font)
                      'katakana-jisx0201
                      (font-spec :family "ＭＳ ゴシック" :size 14))
    ))

;; CLI
(when (not window-system)
  (progn
    ;; UTF-8 support
    (prefer-coding-system       'utf-8)
    (set-default-coding-systems 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-keyboard-coding-system 'utf-8)
    (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
    ))


;; ずれ確認用
;; 0123456789012345678901234567890123456789
;; ｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵ
;; あいうえおあいうえおあいうえおあいうえお
