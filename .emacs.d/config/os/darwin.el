;;; darwin.el
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

;; input method
(defvar my:cursor-color-ime-on "#91C3FF") ;; Cyan
(defvar my:cursor-color-ime-off "#FF9300") ;; White, #999999, #749CCC
(defun my:mac-keyboard-input-source (&optional frame)
  "現在の入力ソースに応じてカーソル色を切り替える（GUIフレームのみ）。"
  (when (and (display-graphic-p frame)
          (fboundp 'mac-input-source))
    (with-selected-frame (or frame (selected-frame))
      (if (string-match "com.apple.keylayout.ABC" (mac-input-source))
        (set-cursor-color my:cursor-color-ime-off)
        (set-cursor-color my:cursor-color-ime-on)
        )
      )
    )
  )

(when (and (fboundp 'mac-auto-ascii-mode)
        (fboundp 'mac-input-source))
  ;; IME ON/OFF でカーソルの種別や色を替える
  (add-hook 'mac-selected-keyboard-input-source-change-hook
    'my:mac-keyboard-input-source)
  (my:mac-keyboard-input-source)
  )


;; fonts & window size
;; GUI
(when window-system
  (progn

    ;; maximize window
    ;; (toggle-frame-maximized)

    ;; set a default font
    (when (member "DejaVu Sans Mono" (font-family-list))
      (set-face-attribute 'default nil :font "DejaVu Sans Mono-9"))

    (when (member "Noto Sans Mono CJK JP" (font-family-list))
      ;; 全角日本語（ひらがな・漢字など）
      (set-fontset-font t 'japanese-jisx0208
        (font-spec :family "Noto Sans Mono CJK JP" :size 14))
      ;; 半角カナ
      (set-fontset-font t 'katakana-jisx0201
        (font-spec :family "Noto Sans Mono CJK JP" :size 14)))

    ;; その他の文字セットを統一
    (set-fontset-font t 'unicode (font-spec :family "Noto Sans Mono CJK JP") nil 'append)
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
