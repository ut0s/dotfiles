;; Time-stamp: <2021-05-30 18:31:01 tagashira>
;; emacs OS依存設定

;; ==========
;; key binding
;; ==========

;; ウィンドウ移動 追加設定
(bind-key* "C-." 'next-multiframe-window)
(bind-key* "C-," 'previous-multiframe-window)


;; ==========
;; Japanese setting
;; ==========
;; (set-language-environment "Japanese")
(set-locale-environment "en_US")

;; mozc
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-mozc") ;; global
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(require 'mozc)
(setq default-input-method "japanese-mozc")
(global-set-key "\M-2" 'toggle-input-method) ;Alt-2 on/off
(setq mozc-candidate-style 'echo-area)

;; ;; anthy
;; (require 'anthy)
;; (load-library "anthy")
;; (set-input-method "japanese-anthy")
;; (setq default-input-method "japanese-anthy")
;; ;; (global-set-key [?\S- ] 'anthy-mode) ;shift-spac on/off
;; ;; (global-set-key [zenkaku-hankaku] 'anthy-mode) ;zenkaku-hankaku on/off


;; fonts & window size
;; GUI
(when window-system
  (progn
    (setq default-frame-alist
          (append
           '(
             ;; (font . "monospace-9") ;; デフォルトフォントセット
             ;; (font . "Takaoゴシック-10") ;; デフォルトフォントセット
              ;; (width . 80) (height . 40) ;; ウィンドウサイズ
             )
           default-frame-alist
           )
          )

    ;; set a default font
    (when (member "DejaVu Sans Mono" (font-family-list))
      (set-face-attribute 'default nil :font "DejaVu Sans Mono-9"))

    ;; 全角かな設定
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      (font-spec :family "Noto Sans Mono CJK JP" :size 14))
    ;; 半角ｶﾅ設定
    (set-fontset-font (frame-parameter nil 'font)
                      'katakana-jisx0201
                      (font-spec :family "Noto Sans Mono CJK JP" :size 14))
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
