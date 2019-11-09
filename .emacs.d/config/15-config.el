;;
;; 15-config.el

;; 現在行をハイライト
(use-package hl-line
  :straight nil
  :config
  (global-hl-line-mode t)
  ;; hl-lineを無効にするメジャーモードを指定する
  (defvar global-hl-line-timer-exclude-modes '(todotxt-mode))
  (defun global-hl-line-timer-function ()
    (unless (memq major-mode global-hl-line-timer-exclude-modes)
      (global-hl-line-unhighlight-all)
      (let ((global-hl-line-mode t))
        (global-hl-line-highlight))))

  (setq global-hl-line-timer
        (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
  ;;(cancel-timer global-hl-line-timer)

  (defface hlline-face
    '((((class color)
        (background dark))
       (:background "dark slate gray"))
      (((class color)
        (background light))
       (:background "ForestGreen"))
      (t
       ()))
    "*Face used by hl-line.")
  (setq hl-line-face 'hlline-face)
  )

;;(show-paren-mode t)
;; 括弧のハイライトの設定。mixed,parenthesis,expression
(setq show-paren-style 'mixed)
;; 選択範囲をハイライト
;;(transient-mark-mode t)

;;
;;find-file時にバックアップファイルなども表示しない
(defadvice completion-file-name-table (after ignoring-backups-f-n-completion activate)
  "filter out results when the have completion-ignored-extensions"
  (let ((res ad-return-value))
    (if (and (listp res)
             (stringp (car res))
             (cdr res)) ; length > 1, don't ignore sole match
        (setq ad-return-value
              (completion-pcm--filename-try-filter res)))))

;; バックアップとオートセーブファイルを~/.emacs.d/.backup/へ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/.backup/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/.backup/") t)))



;;
;;shebangが付いているファイルのパーミッションを保存時に +x にしてくれる設定
(add-hook 'after-save-hook 'my-chmod-script)
(defun my-chmod-script() (interactive) (save-restriction (widen)
                                                         (let ((name (buffer-file-name)))
                                                           (if (and (not (string-match ":" name))
                                                                    (not (string-match "/\\.[^/]+$" name))
                                                                    (equal "#!" (buffer-substring 1 (min 3 (point-max)))))
                                                               (progn (set-file-modes name (logior (file-modes name) 73))
                                                                      (message "Wrote %s (chmod +x)" name)
                                                                      ))
                                                           )))



;;
;;desktopの設定
(use-package desktop
  :straight nil
  :config
  (setq desktop-path (list "~/.emacs.d/.emacs.desktop/"))
  (desktop-save-mode 1)
  ;; Customization goes between desktop-load-default and desktop-read
  (setq history-length 1000)
  :hook (after-save-hook . desktop-save-in-desktop-dir)
  :hook (kill-emacs-hook . desktop-save-in-desktop-dir)
  )




;;矢印の無効化＆キーの割当
;;(global-set-key [up] 'shell-pop)
(global-set-key [right] 'next-buffer)
;;(global-set-key [down] 'indent-region)
(global-set-key [left] 'previous-buffer)

;;
;;Folding
(use-package cc-mode
  :straight nil
  :config
  (add-hook 'c++-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (add-hook 'c-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (add-hook 'emacs-lisp-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (add-hook 'lisp-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (add-hook 'python-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (add-hook 'xml-mode-hook
            '(lambda ()
               (hs-minor-mode 1)))
  (bind-key "C-\\" 'hs-toggle-hiding c-mode-base-map)
  )


;;
;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;;
;;縦のスクロールバーを消す
(scroll-bar-mode -1)
;;
;;横方向のスクロールバーを消す
(custom-set-variables
 '(horizontal-scroll-bar nil))

(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 2
                                  tab-width 2
                                  indent-tabs-mode nil)))

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

;; server start for emacs-client
(use-package server
  :straight nil
  :if window-system
  :init
  (server-start)
)


;; ;;
;; ;;set a default font
;; (when (member "DejaVu Sans Mono" (font-family-list))
;;   (set-face-attribute 'default nil :font "DejaVu Sans Mono"))
;; ;; 全角かな設定
;; (set-fontset-font t 'japanese-jisx0208 "TakaoPGothic")
;; ;; 半角ｶﾅ設定
;; ;; (set-fontset-font t 'japanese-jisx0201 "TakaoPGothic")


(defun reopen-with-sudo ()
  "Reopen current buffer-file with sudo using tramp."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))
(bind-key* "C-x C-a" 'reopen-with-sudo)

(bind-key* "C-x C-s" 'save-buffer)

;;
;; replace ten-maru to commma-period
(defun replace-punctuation (a1 a2 b1 b2)
  "Replace periods and commas"
  (let ((s1 (if mark-active "selected region" "Buffer"))
        (s2 (concat a2 b2))
        (b (if mark-active (region-beginning) (point-min)))
        (e (if mark-active (region-end) (point-max))))
    (if (y-or-n-p (concat "Does " s1 " replace to " s2 "??"))
        (progn
          (replace-string a1 a2 nil b e)
          (replace-string b1 b2 nil b e)))))

;; (defun replace-punctuation-ten-to-maru ()
;;   "replace to [、。]"
;;   (interactive)
;;   (replace-punctuation "，" "、" "．" "。"))

(defun replace-punctuation-comma-to-period ()
  "replace to [，．]"
  (interactive)
  (replace-punctuation "、" "，" "。" "．"))

(defun replace-zenkaku-space-to-hankaku ()
  "replace [　] to space"
  (interactive)
  (replace-punctuation "　" " " " " " "))

(defun replace-underline-to-hyphen ()
  "replace underline to hyphen"
  (interactive)
  (replace-punctuation "_" "-" "_" "-"))

(defun replace-hyphen-to-underline ()
  "replace hypen to underline"
  (interactive)
  (replace-punctuation "-" "_" "-" "_"))

;;
;;shell
(setq sh-basic-offset 2)

;; insert newline at end of file
(setq require-final-newline t)

;; indicate empty lines by showing fringe
(setq-default indicate-empty-lines t)
