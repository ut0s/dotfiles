;; 01-myconfig.el

;;
;; key binding

;; C-h = backspace
(bind-key* "\C-h" 'delete-backward-char)

;; jump to correrspoinding bracket
(bind-key* "\M-n" 'forward-list)
(bind-key* "\M-p" 'backward-list)

;; shift- arrow でウィンドウ間を移動
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;; comment, uncomment
(bind-key* "\C-cc" 'comment-or-uncomment-region)


;; 背景の設定
(set-background-color "black");; 標準の背景色
(set-face-background 'default "black");; 標準の背景色
(set-face-foreground 'default "white");; 標準の文字色

;; hilit19 の設定
(setq hilit-background-mode 'light);; 背景色が明るい色
;; (setq hilit-background-mode 'dark);; 背景色が暗い色

;; font-lock-mode
(global-font-lock-mode t);; 色をつける
(setq font-lock-maximum-decoration t);; font-lockで の装飾レベル
(setq fast-lock nil)
(setq lazy-lock nil)
(setq jit-lock t)

;; japanese coding setting
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; 背景を半透明に
(setq default-frame-alist
      (append (list
               '(alpha . (75 75))
               )
              default-frame-alist))

;; disable automatic indent
(electric-indent-mode -1)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; disable auto fill mode
(setq auto-fill-mode nil)
(global-visual-line-mode) ; 英単語の途中で折り返さない

;; C-k(kill-line) setting
(setq kill-whole-line t)

;; scroll setting
(setq scroll-step 1); vertial scroll by 1 line
(setq next-screen-context-lines 3); overlap lines of page-down

;; emphasize ( )
;; 対応する括弧をハイライト
(show-paren-mode t)

;; frame-title
;; display buffer name
(setq frame-title-format
      `("%f""@",(system-name);; %f:absolute path, %b:file name
        ))

;; tool bar and menu bar
(tool-bar-mode -1) ;; nil?
(menu-bar-mode -1) ;; nil?

;; don't show title window
(setq inhibit-startup-message t)

;; backup file setting
;; filename~ => filename.~n~
;; (setq version-control t)
;; (setq kept-old-versions 1)
;; (setq kept-new-versions 2)
;; (setq trim-versions-without-asking t)
;;(setq make-backup-files nil); don't create *~
(setq auto-save-default t); create backup file #*#

;;visible-bell
(setq visible-bell t)

;;行・列番号を表示する
(line-number-mode t)
(column-number-mode t)



