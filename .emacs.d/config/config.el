(defconst my/before-load-init-time (current-time))

;;;###autoload
(defun my/load-init-time ()
  "Loading time of user init files including time for `after-init-hook'."
  (let ((time1 (float-time
                (time-subtract after-init-time my/before-load-init-time)))
        (time2 (float-time
                (time-subtract (current-time) my/before-load-init-time))))
    (message (concat "Loading init files: %.0f [msec], "
                     "of which %.f [msec] for `after-init-hook'.")
             (* 1000 time1) (* 1000 (- time2 time1)))))
(add-hook 'after-init-hook #'my/load-init-time t)

(defvar my/tick-previous-time my/before-load-init-time)

;;;###autoload
(defun my/tick-init-time (msg)
  "Tick boot sequence at loading MSG."
  (when my/loading-profile-p
    (let ((ctime (current-time)))
      (message "---- %5.2f[ms] %s"
               (* 1000 (float-time
                        (time-subtract ctime my/tick-previous-time)))
               msg)
      (setq my/tick-previous-time ctime))))

(defun my/emacs-init-time ()
  "Emacs booting time in msec."
  (interactive)
  (message "Emacs booting time: %.0f [msec] = `emacs-init-time'."
           (* 1000
              (float-time (time-subtract
                           after-init-time
                           before-init-time)))))

(add-hook 'after-init-hook #'my/emacs-init-time)

(defconst my/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq gc-cons-threshold (* 128 1024 1024))

;;; OS
(add-to-list 'load-path "~/.emacs.d/config/os/")

(defvar os-type nil)

(cond
  ((string-match "linux" system-configuration)        ;; Linux
    (load "linux.el")
    )
  ((string-match "mingw" system-configuration)        ;; Windows
    (load "win.el")
    )
  ((string-match "apple-darwin" system-configuration) ;; Mac
    (load "darwin.el")
    )
  ((string-match "freebsd" system-configuration)      ;; FreeBSD
    (load "linux.el")
    )
  )

;; C-h = backspace
(bind-key* "\C-h" 'delete-backward-char)

;; jump to correrspoinding bracket
(bind-key* "\M-n" 'forward-list)
(bind-key* "\M-p" 'backward-list)

;; shift- arrow でウィンドウ間を移動
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;; comment, uncomment
(bind-key* "\C-cc" 'comment-or-uncomment-region)

;; save buffer
(bind-key* "C-x C-s" 'save-buffer)

;; replace-regexp
(bind-key* "C-M-%" 'query-replace-regexp)
(bind-key* "C-M-5" 'query-replace-regexp)

;; 背景の設定
(set-background-color "black");; 標準の背景色
(set-face-background 'default "black");; 標準の背景色
(set-face-foreground 'default "white");; 標準の文字色

;; hilit19 の設定
(setq hilit-background-mode 'light);; 背景色が明るい色
;; (setq hilit-background-mode 'dark);; 背景色が暗い色

;; font-lock-mode
(global-font-lock-mode t);; 色をつける
(setq font-lock-maximum-decoration t);; font-lockで の装飾レベル
(setq fast-lock nil)
(setq lazy-lock nil)
(setq jit-lock t)

;; japanese coding setting
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; 背景を半透明に
(setq default-frame-alist (append (list '(alpha . (75 75))) default-frame-alist))

;; disable automatic indent
(electric-indent-mode -1)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; disable auto fill mode
(setq auto-fill-mode nil)
(global-visual-line-mode) ; 英単語の途中で折り返さない

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
(setq frame-title-format `("%f""@",(system-name);; %f:absolute path, %b:file name
     ))

;; tool bar and menu bar
(if window-system
  (tool-bar-mode -1) ;; nil?
  (menu-bar-mode -1) ;; nil?
)

;; don't show title window
(setq inhibit-startup-message t)

;; backup file setting
;; filename~ => filename.~n~
;; (setq version-control t)
;; (setq kept-old-versions 1)
;; (setq kept-new-versions 2)
;; (setq trim-versions-without-asking t)
;;(setq make-backup-files nil) ;; don't create *~
(setq auto-save-default t) ;; create backup file #*#

;;visible-bell
(setq visible-bell t)

;;行・列番号を表示する
(line-number-mode t)
(column-number-mode t)

;; バッファの最後でnewlineで新規行を追加するのを禁止する
;; (setq next-line-add-newlines nil)

;;
;;whitespace
(use-package whitespace
  :ensure nil
  :config (global-whitespace-mode 1)
  (setq whitespace-style '(face           ; faceで可視化
                            trailing       ; 行末
                            tabs           ; タブ
                            spaces         ; スペース
                            empty          ; 先頭/末尾の空行
                            space-mark     ; 表示のマッピング
                            tab-mark))
  (setq whitespace-display-mappings '((space-mark ?\u3000 [?\u25a1])
                                       ;; WARNING: the mapping below has a problem.
                                       ;; When a TAB occupies exactly one column, it will display the
                                       ;; character ?\xBB at thacot lumn followed by a TAB which goes to
                                       ;; the next TAB column.
                                       ;; If this is a problem for you, please, comment the line below.
                                       (tab-mark ?\t [?\u00BB ?\t]
                                         [?\\ ?\t])))

  ;; スペースは全角のみを可視化
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  ;; 保存前に自動でクリーンアップ
  (setq whitespace-action '(auto-cleanup))
  :custom-face (whitespace-trailing ((t (:foreground "DeepPink"
                                          :background "orange"
                                          :underline t))))
  (whitespace-tab ((t (:foreground "LightSkyBlue"
                        :underline t))))
  (whitespace-space ((t (:foreground "GreenYellow"
                          :background "orange"
                          :bold t))))
  (whitespace-empty ((t (:background "orange"
                          :bold t)))))

(fset 'yes-or-no-p 'y-or-n-p)

(setq history-delete-duplicates t)

(setq vc-follow-symlinks t)

;;
;;find-file時にバックアップファイルなども表示しない
(defadvice completion-file-name-table  (after ignoring-backups-f-n-completion activate)
  "filter out results when the have completion-ignored-extensions"
  (let ((res ad-return-value))
    (if (and (listp res)
          (stringp (car res))
          (cdr res)) ; length > 1, don't ignore sole match
      (setq ad-return-value (completion-pcm--filename-try-filter res)
        )
      )
    )
  )

;;
;;縦のスクロールバーを消す
(use-package emacs
  :if window-system
  :ensure nil
  :config
  (scroll-bar-mode -1)
  )
;;
;;横方向のスクロールバーを消す
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(horizontal-scroll-bar nil t)
  '(org-safe-remote-resources '("\\`https://fniessen\\.github\\.io/org-html-themes/org/theme-readtheorg\\.setup\\'")
     )
  )

;; server start for emacs-client
(use-package emacs
  :ensure nil
  :init (server-force-delete)
  (server-start)
  )

(use-package emacs
  :ensure nil
  :bind
  ("<up>" . next-multiframe-window)
  ("<right>" . next-buffer)
  ("<left>" . previous-buffer)
  )

(use-package emacs
  :ensure nil
  :init (desktop-save-mode 1)
  :custom
  ;; Customization goes between desktop-load-default and desktop-read
  ;; (desktop-save t)
  (history-length 1000)
  (desktop-auto-save-timeout 60)
  (desktop-restore-eager 4)
  :hook (
          (after-save . desktop-save-in-desktop-dir)
          (kill-emacs . desktop-save-in-desktop-dir)
          )
  )

(use-package emacs
  :ensure nil
  :init (savehist-mode t)
  ;; :custom
  )

(setq require-final-newline t)

(use-package emacs
  :ensure nil
  :config
  (defun my/up-directory ()
    "Minibuffer で親ディレクトリに移動する。"
    (interactive)
    (when minibuffer-completing-file-name
      (let ((dir (file-name-directory (minibuffer-contents))))
        (when dir
          (delete-minibuffer-contents)
          (insert (file-name-directory (directory-file-name dir)))))))
  :bind (:map minibuffer-local-map
          ("C-l" . #'my/up-directory)
          )
  )

(use-package comp
  :ensure nil
  :disabled
  :config
  (setq native-comp-async-jobs-number 8)
  (setq native-comp-speed 3)
  )

;; (native-compile-async "~/.emacs.d/early-init.el")
;; (native-compile-async "~/.emacs.d/init.el")

;; バックアップとオートセーブファイルを~/.emacs.d/.backup/へ集める
(setq make-backup-files t)
(setq backup-directory-alist (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/.backup")) backup-directory-alist))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "~/.emacs.d/.backup/") t)))

(defun reopen-with-sudo () "Reopen current buffer-file with sudo using tramp." (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))
(bind-key* "C-x C-a" 'reopen-with-sudo)

(defun kill-other-buffers () "kill all other buffers." (interactive)
  (mapc 'kill-buffer (delq (current-buffer)
                       (buffer-list))))

(bind-key "<f9>" 'toggle-menu-bar-mode-from-frame)

(setq-default indicate-empty-lines t)

(use-package emacs
  :ensure nil
  :config
  (global-hl-line-mode t)
  :custom-face
  (hl-line
   ((((class color) (background dark))
     (:background "dark slate gray" :extend t))
    (((class color) (background light))
     (:background "ForestGreen" :extend t))))
  )

;;
;;exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize)
  )

(use-package flyspell
  :ensure nil
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")) ;;日本語のなかでも英語のチェックをする
  (add-to-list 'ispell-skip-region-alist '("^#+BEGIN_SRC" . "^#+END_SRC"))
  ;; (setq ispell-program-name "aspell")
  (setq ispell-program-name "/opt/homebrew/bin/aspell")
  (setq ispell-extra-args '("--lang=en_US"))
  ;; ここに書いたモードではコメント領域のところだけ flyspell-mode が有効になる
  ;; ここに書いたモードでは flyspell-mode が有効になる
  :hook (
          (c-mode-common . flyspell-prog-mode)
          (emacs-lisp-mode . flyspell-prog-mode)
          (yatex-mode . flyspell-mode)
          (org-mode . flyspell-mode)
          )
  ;; set face
  :custom-face
  (flyspell-duplicate ((t (:foreground "white" :box nil :bold nil :underline nil))))
  (flyspell-incorrect ((t (:box t :underline nil))))
  )

(use-package dired-x
  :ensure nil
  :defer t
  :bind ("C-x C-j" . dired-jump)
  :bind (:map dired-mode-map
          ("(" . dired-hide-details-mode)
          ;; ("r" . wdired-change-to-wdired-mode)
          ;; ("C-h" . dired-omit-mode)
          ("C-l" . dired-up-directory)
          )
  :config
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil)
    (setq insert-directory-program "gls")
    )
  (setq
    dired-isearch-filenames t
    dired-listing-switches "-laGh1v"
    ;; recursion
    dired-recursive-copies 'always
    dired-recursive-deletes 'always
    ;; Move deleted files to trash
    delete-by-moving-to-trash t
    )
  )

(use-package wdired
  :ensure nil
  :defer t
  :bind (:map dired-mode-map
          ("C-c C-q" . wdired-change-to-wdired-mode)
          )
  :config
  (setq wdired-allow-to-change-permissions t)
  )

;; Reuse the current dired buffer to visit a directory
(use-package dired-single
  :ensure  (
            :host github
            :repo "emacsattic/dired-single"
            :branch "master"
            :depth 1
            :protocol https
            :files ("*")
            )
  :defer t
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  :bind (:map dired-mode-map
          ("C-m" . dired-single-buffer)
          )
  )

(use-package dired-ranger
  :ensure t
  :defer t
  ;; :bind (:map dired-mode-map
  ;;         ("W" . dired-ranger-copy)
  ;;         ("X" . dired-ranger-move)
  ;;         ("Y" . dired-ranger-paste)
  ;;         )
  )

(use-package expand-region
  :ensure t
  :config
  ;; 真っ先に入れておかないとすぐに括弧に対応してくれない…
  (push 'er/mark-outside-pairs er/try-expand-list)
  :bind ("C-=" . er/expand-region)
  )

(use-package recentf
  :ensure nil
  :defer t
  :init
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf" "COMMIT_EDITMSG" "/.?TAGS"))
  (setq recentf-auto-cleanup 'never)
  (run-with-idle-timer 30 t '(lambda ()
                               (with-suppressed-message (recentf-save-list)))) ;; 30秒に一度自動保存
  (recentf-mode 1)
  )

(use-package recentf-ext
  :ensure t
  )

(use-package yasnippet
  :ensure (
            :host github
            :repo "joaotavora/yasnippet"
            :branch "master"
            :depth 1
            :protocol https
            :files ("*")
            )
  :defer t
  :commands (yas-insert-snippet)
  :config
  ;; yas起動
  (setq yas-snippet-dirs (list
                            (expand-file-name "~/.emacs.d/misc/mysnippets") ;; 自分用のスニペットフォルダ
                            (expand-file-name "~/.emacs.d/misc/snippets")   ;; ダウンロードしたもの
                            )
    )

  (yas-global-mode 1)
  ;; :bind (:map yas-minor-mode-map
  ;;         ("C-x i" . yas-insert-snippet)
  ;;         )
  :bind ("C-c i s" . yas-insert-snippet)
  )

(use-package transient
  :ensure t
  :defer t
  )

;;
;;magit
(use-package magit
  :ensure t
  :defer t
  :config
  ;; always show recent commits section
  (setf (alist-get 'unpushed magit-section-initial-visibility-alist) 'show)
  :bind ("C-x g" . magit-status)
  :custom-face
  (magit-diff-added ((t (:background "black"
                          :foreground "green"))))
  (magit-diff-added-highlight ((t (:background "black"
                                    :foreground "green"))))
  (magit-diff-removed ((t (:background "black"
                            :foreground "red"))))
  (magit-diff-removed-hightlight ((t (:background "black"
                                       :foreground "red"))))
  (magit-hash ((t (:background "black"
                    :foreground "green"))))
  )

;;
;; ediff config
;; Stop the control panel in a separate frame.
(use-package ediff
  :ensure nil
  :defer t
  :bind ("C-c e d" . ediff-files)
  :config (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)

  ;; restore windonw configuration after ediff
  (defvar pre-ediff-window-configuration nil "window configuration to restore")
  (defvar new-ediff-frame-to-use nil "new frame for ediff to use")
  (defun save-my-window-configuration () "save window layput before ediff" (interactive)
    (setq pre-ediff-window-configuration (current-window-configuration))
    (delete-other-windows)
    (select-frame-set-input-focus (setq new-ediff-frame-to-use (selected-frame))))
  (defun restore-my-window-configuration () "load window layput after ediff" (interactive)
    (when (framep new-ediff-frame-to-use)
      ;;(delete-frame new-ediff-frame-to-use)
      (setq new-ediff-frame-to-use nil))
    (when (window-configuration-p pre-ediff-window-configuration)
      (set-window-configuration pre-ediff-window-configuration)))

  ;;set hook for ediff to restore layout
  :hook((ediff-before-setup-hook . save-my-window-configuration)
         (ediff-after-quit-hook-internal . restore-my-window-configuration)
         )
  )

;; easy-template
(use-package org-tempo
  :ensure nil
  :if (version<= "9.2" (org-version))
  :after (org)
  )

;; compat
;; (if (fboundp 'file-name-concat)
;;   ;; (defalias 'org-file-name-concat #'file-name-concat)
;;   (defalias 'org-file-name-concat 'file-name-concat)
;;   (defun org-file-name-concat (directory &rest components)
;;     "Append COMPONENTS to DIRECTORY and return the resulting string.

;; Elements in COMPONENTS must be a string or nil.
;; DIRECTORY or the non-final elements in COMPONENTS may or may not end
;; with a slash -- if they don't end with a slash, a slash will be
;; inserted before contatenating."
;;     (save-match-data
;;       (mapconcat
;;         #'identity
;;         (delq nil
;;           (mapcar
;;             (lambda (str)
;;               (when (and str (not (seq-empty-p str))
;;                       (string-match "\\(.+\\)/?" str))
;;                 (match-string 1 str)))
;;             (cons directory components)))
;;         "/"))))

(use-package htmlize
  :ensure t
  :defer t
  :after (org)
  )

(use-package emacs
  ;; :ensure t
  :ensure nil
  :defer t
  :config
  (setq
    org-src-fontify-natively t
    org-src-tab-acts-natively t
    org-startup-with-inline-images nil
    org-confirm-babel-evaluate nil
    org-startup-folded 'content
    org-fontify-whole-heading-line t
    org-edit-src-content-indentation 0
    org-use-speed-commands t
    org-startup-indented t
    org-indent-mode-turns-on-hiding-stars nil
    org-indent-indentation-per-level 2
    org-tags-column 0
    calendar-week-start-day 1
    org-hide-emphasis-markers nil
    org-id-link-to-org-use-id 'use-existing
    org-display-remote-inline-images 'cache
    org-return-follows-link nil
    org-element-use-cache nil
    ;; todo
    org-enforce-todo-dependencies t
    org-todo-keywords
    '((sequence "TODO(t!)" "RESOURCE(r!)" "HANDOVER(h!)" "URGENT(u!)" "WAIT(w!)" "|" "DONE(d!)" "CANCELED(c!)"))
    ;; tag/property
    org-use-tag-inheritance "ARCHIVE"
    ;; org-tags-column -57
    org-global-properties
    ;; effort
    '(("Effort_ALL". "0 0:15 0:30 0:45 1:00 1:30 2:00 3:00 4:00 6:00 8:00"))
    org-use-property-inheritance "TIMELIMIT.*"
    ;; priority
    org-highest-priority ?A
    org-lowest-priority ?Z
    org-default-priority ?E
    ;; face
    org-todo-keyword-faces
    '(
       ("RESOURCE" . (:foreground "green" :weight bold))
       ("URGENT" . (:foreground "red2" :weight bold))
       ("HANDOVER" . (:foreground "orange1" :weight bold))
       ("WAIT" . (:foreground "SpringGreen" :weight bold))
       ;; ("CANCELED" . (:weight bold))
       )
    org-cycle-separator-lines 0
    ;; logging
    org-log-into-drawer t
    org-log-done 'time
    org-log-states-order-reversed t
    org-reverse-note-order nil
    ;; archive
    org-archive-location "~/DEV/orgfiles/archive.org"
    )

  ;;Define Custom Function
  (defun my/org-open-at-point-eww (&optional arg)
    (interactive "p")
    (if (not arg)
      (org-open-at-point)
      (let ((browse-url-browser-function #'browse-url-eww))
        (org-open-at-point))))
  ;; (bind-key "C-c C-o" 'my-org-open-at-point-eww org-mode-map)
  ;; (bind-key "C-c C-O" 'my-org-open-at-point org-mode-map)

  ;; (defun my/org-add-ids-to-headlines-in-file ()
  ;;   "Add ID properties to all headlines in the current file which do not already have one."
  ;;   (interactive)
  ;;   (org-map-entries 'org-id-get-create))

(defun my/org-add-ids-to-non-link-headlines-in-file ()
  "Add ID properties to non-link headlines in the current file which do not already have one."
  (interactive)
  (org-map-entries
   (lambda ()
     (let* ((element (org-element-at-point))
            (type (org-element-type element))
            (raw-value (org-element-property :raw-value element)) ; 見出しテキストを取得
            (has-id (org-entry-get (point) "ID")) ; 既存のIDを確認
            (contains-link (string-match-p org-link-bracket-re raw-value))) ; リンクが含まれるか確認
       ;; 見出しがリンクを含まず、IDがない場合にIDを作成
       (when (and (eq type 'headline) ; 要素が見出し
                  (not contains-link) ; 見出しにリンクが含まれない
                  (not has-id)) ; 既存のIDがない
         (org-id-get-create))))))

  (add-hook 'org-mode-hook
    (lambda ()
      (add-hook 'before-save-hook 'my/org-add-ids-to-non-link-headlines-in-file nil 'local)))



  (defun html2org-yank (start end)
    (interactive "r")
    (if (use-region-p)
      (let ((selectedURL (buffer-substring-no-properties start end)))
        (forward-line)
        (if (string-match "qiita.com" selectedURL)
          (insert (shell-command-to-string (format "$HOME/dotfiles/.emacs.d/bin/html2org-qiita.py %S " selectedURL)))
          (if (string-match "wikipedia.org" selectedURL)
            (insert (shell-command-to-string (format "$HOME/dotfiles/.emacs.d/bin/html2org-wikipedia.py %S " selectedURL)))
            (insert (shell-command-to-string (format "pandoc -S --wrap=none --normalize --tab-stop=2 -f html -t org %S | sed -e 's#。#．#g' -e 's#、#，#g'" selectedURL)))
            )
          )
        (message selectedURL)
        )
      )
    )

  (bind-key "C-c C-g" 'html2org-yank org-mode-map)

  (defun imdb_info2org-yank (start end)
    (interactive "r")
    (if (use-region-p)
      (let ((selectedURL (buffer-substring-no-properties start end)))
        (forward-line)
        (if (string-match "anidb" selectedURL)
          (insert (shell-command-to-string (format "get_aniDB_info org %S" selectedURL)))
          (if (string-match "uta-net" selectedURL)
            (insert (shell-command-to-string (format "get_utanet_lyric %S" selectedURL)))
            (insert (shell-command-to-string (format "get_IMDB_info org %S" selectedURL)))
            )
          (message selectedURL)
          )
        )
      )
    )

  (bind-key "C-c C-i" 'imdb_info2org-yank org-mode-map)

  (defun org-replace-link-by-link-description ()
    "Replace an org link by its description or if empty its address"
    (interactive)
    (if (org-in-regexp org-link-bracket-re 1)
      (let ((remove (list (match-beginning 0) (match-end 0)))
             (description (if (match-end 3)
                            (match-string-no-properties 3)
                            (match-string-no-properties 1))))
        (apply 'delete-region remove)
        (insert description))
      )
    )

  (bind-key "C-c u" 'org-replace-link-by-link-description org-mode-map)

  (add-to-list 'org-emphasis-alist
    '("_" (:background "yellow" :foreground "black")
       ))

  ;;org-babel
  (when (string= system-type "darwin")
    (setq org-babel-C++-compiler "clang++")
    )
  ;; Must have org-mode loaded before we can configure org-babel
  ;; Some initial langauges we want org-babel to support
  (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
  (org-babel-do-load-languages
    'org-babel-load-languages
    '(
       (shell . t)
       (lisp . t)
       (python . t)
       (C . t)
       (dot . t)
       (latex . t)
       ;; (typescript . t)
       )
    )
  (setq org-babel-python-command "python3")

  ;; src block
  (setq org-src-window-setup 'current-window)
  :hook (before-save . org-babel-post-tangle-hook)
  )

(use-package org-cliplink
  :disabled
  :ensure t
  :after (org)
  :bind ("C-x p i" . org-cliplink)
  )


;;
;;org-agenda
(use-package org-agenda
  :ensure nil
  ;; :after (org)
  :config
  (setq org-directory "~/orgfiles/")
  (setq org-agenda-files "~/orgfiles/log/log.org")
  ;; (setq org-agenda-files '(
  ;;                           "~/orgfiles/"
  ;;                           )
  ;;   )
  ;; (setq org-agenda-file-regexp "\\`[^.].*\\.org'\\|[0-9]+.org$")


  (setq org-agenda-inhibit-startup t)
  ;; 時間表示が 1 桁の時, 0 をつける
  (setq org-agenda-time-leading-zero t)
  ;; default で logbook を表示
  (setq org-agenda-include-inactive-timestamps t)

  ;; default で 時間を表示
  (setq org-agenda-start-with-log-mode t)

  (setq org-tag-alist
    '((:startgroup . nil)
       ("HOME" . ?h) ("OFFICE" . ?o)("IPNSPR" . ?i)("KEKPR" . ?k)
       (:endgroup . nil)
       (:newline . nil)
       (:startgroup . nil)
       ("TOPICS" . ?t) ("PRESS" . ?p)("HIGHLIGHT" . ?l)("EVENT" . ?e)
       (:endgroup . nil)
       (:newline . nil)
       (:startgroup . nil)
       ("T2K" . nil) ("BELLE" . nil)("COMET" . nil)
       (:endgroup . nil)
       (:newline . nil)
       (:startgroup . nil)
       ("READING" . ?r) ("WRITING" . ?w)("ASKING" . ?a)
       (:endgroup . nil))
    )

  (setq org-agenda-time-grid
    '((daily today require-timed)
       "----------------"
       ;; (900 1000 1100 1200 1300 1400 1500 1600 1700)))
       (000 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300)))

  :bind ("M-<f6>" . org-agenda)
  )


;;
;;org-roam
(use-package org-roam
  :if window-system
  :ensure t
  :after (org)
  :config
  ;; open in side
  ;; (add-to-list 'display-buffer-alist
  ;;   '("\\*org-roam\\*"
  ;;      (display-buffer-in-side-window)
  ;;      (side . right)
  ;;      (slot . 0)
  ;;      (window-width . 0.33)
  ;;      (window-parameters . ((no-other-window . t)
  ;;                             (no-delete-other-windows . t)))))
  (setq org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame)))
  :custom
  (org-roam-db-update-method 'immediate)
  (org-roam-db-location "~/.emacs.d/org-roam.db")
  (org-roam-directory "~/DEV/orgfiles/roam/")
  (org-roam-index-file "~/DEV/orgfilesg/roam.org")
  ;; (org-roam-extract-new-file-path "%<%Y%m%d>-${slug}.org")
  (org-roam-db-update-on-save t)
  (org-roam-db-autosync-mode t)
  :hook
  (after-init . org-roam-mode)
  (org-roam-mode . org-roam-db-autosync-mode)
  :bind (
          :map org-mode-map
          (
            ("C-c n l" . org-roam-buffer-toggle)
            ("C-c n i" . org-roam-node-insert)
            ("C-c n f" . org-roam-node-find)
            ("C-c n g" . org-roam-graph)
            ("C-c n c" . org-roam-capture)
            )
          )
  )

(use-package org-web-tools
  :ensure t
  :bind (:map org-mode-map
          (
            ("C-c i l" . org-web-tools-insert-link-for-url)
            )
          )
  )


;;
;;ox-hugo
;;https://github.com/kaushalmodi/ox-hugo/discussions/551
(use-package ox-hugo
  :ensure t
  :after (ox)
  :config
  (eval . (org-hugo-auto-export-mode))
  (setq org-element-use-cache nil)
  )

;;
;;ob-rust
(use-package ob-rust
  :ensure t
  :after (org)
  )

;;
;;ob-typescript
(use-package ob-typescript
  :disabled
  :ensure t
  :after (org)
  )

;;
;;ob-javascript
(use-package ob-js
  :disabled
  :ensure t
  :after (org)
  )

;;
;;org-habit
(use-package org-habit
  :ensure nil
  :after (org)
  )

(use-package org-sticky-header
  :ensure t
  :defer t
  :hook (org-mode . org-sticky-header-mode)
  :config
  ;; Show full path in header
  (setq org-sticky-header-full-path 'full)
  ;; Use > instead of / as separator
  (setq org-sticky-header-outline-path-separator " > ")
  )

(use-package auth-source
  :ensure nil
  :init
  (setq auth-source-debug t)
  (setq epg-gpg-program "gpg")
  (setq auth-sources '("~/.authinfo.gpg"))
  )

(use-package shfmt
  :ensure t
  :defer t
  :hook (
          (sh-mode . shfmt-on-save-mode)
          (bash-ts-mode . shfmt-on-save-mode)
          )
  :custom
  (shfmt-arguments '("-i" "2" "-bn" "-ci" "-sr"))
  )

(use-package elisp-format
  :disabled
  :ensure (
            :host github
            :repo "Yuki-Inoue/elisp-format"
            :branch "master"
            :depth 1
            :protocol https
            :files ("elisp-format.el")
            )
  )

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  ;;(sp-pair "<" ">")
  )

(use-package migemo
  :if (eq system-type 'darwin)
  :config
  ;; cmigemo(default)
  (add-to-list 'exec-path (expand-file-name "/opt/homebrew/bin")) ;; cmigemo
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--nonewline" "--emacs"))
  ;; Set your installed path
  (setq migemo-dictionary "/opt/homebrew/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (migemo-init)
  )

(use-package highlight-symbol
  :ensure t
  :defer t
  :bind (
          ("C-<f3>" . highlight-symbol)
          ("<f3>" . highlight-symbol-next)
          ("S-<f3>" . highlight-symbol-prev)
          ("M-<f3>" . highlight-symbol-query-replace)
          )
  :config
  (highlight-symbol-mode  t)
  (setq highlight-symbol-idle-delay 0.5)
  :hook (flycheck-mode . highlight-symbol-mode)
  ;;自動ハイライト
  :hook (highlight-indentation-mode . highlight-symbol-mode)
  ;;ソースコードにおいてM-p/M-nでシンボル間を移動
  :hook (highlight-symbol-mode . highlight-symbol-nav-mode)
  )

(use-package atomic-chrome
  :if window-system
  :ensure t
  :defer t
  :init
  (atomic-chrome-start-server)
  :config
  (setq atomic-chrome-enable-auto-update t)
  (setq atomic-chrome-server-ghost-text-port 4002)
  (setq atomic-chrome-buffer-open-style 'split)
  )

(use-package flycheck
  :ensure t
  :defer t
  ;; :init (global-flycheck-mode)
  ;;(define-key global-map (kbd "\C-s") 'flycheck-next-error);Ctrl+sで次のエラーへ
  ;;(define-key global-map (kbd "\C-w") 'flycheck-previous-error);Ctrl+wで前のエラーへ
  ;;(define-key global-map (kbd "\C-a") 'flycheck-list-errors);Ctrl+aでエラー表示
  :config (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  ;; :mode ("\\.org\\'" . flycheck-mode)
  :hook (
          (org-mode . flycheck-mode)
          )
  )

(use-package google-translate
  :ensure t
  :defer t
  :config
  (setq google-translate-backend-method 'curl)
  (defvar google-translate-english-chars "[:ascii:]’“”–" "これらの文字が含まれているときは英語とみなす")
  (defun google-translate-enja-or-jaen (&optional string) "regionか、現在のセンテンスを言語自動判別でGoogle翻訳する。" (interactive)
    (setq string (cond ((stringp string) string)
                   (current-prefix-arg (read-string "Google Translate: "))
                   ((use-region-p)
                     (buffer-substring (region-beginning)
                       (region-end)))
                   (t (save-excursion (let (s)
                                        (forward-char 1)
                                        (backward-sentence)
                                        (setq s (point))
                                        (forward-sentence)
                                        (buffer-substring s (point)))))))
    (let* ((asciip (string-match (format "\\`[%s]+\\'" google-translate-english-chars) string)))
      (run-at-time 0.1 nil 'deactivate-mark)
      (google-translate-translate (if asciip "en" "ja")
        (if asciip "ja" "en") string)))
  ;; Fix error of "Failed to search TKK"
  (defun google-translate--get-b-d1 ()
    ;; TKK='427110.1469889687'
    (list 427110 1469889687))
  :bind ("C-c t" . google-translate-enja-or-jaen)
)

(use-package nov
  :ensure t
  :if window-system
  :defer t
  :mode ("\\.epub\\'" . nov-mode)
  :custom
  (nov-variable-pitch nil)
  (nov-text-width t)
  :config
  :bind (:map nov-mode-map
          ("C-j" . nov-browse-url)
          )
  )

(use-package w3m
  :ensure t
  :defer t
  :after (markdown-mode)
  :config (defun w3m-browse-url-other-window (url &optional newwin)
            (let ((w3m-pop-up-windows t))
              (if (one-window-p)
                (split-window))
              (other-window 1)
              (w3m-browse-url url newwin)))
  (defun markdown-preview-by-eww ()
    (interactive)
    (message (buffer-file-name))
    (call-process "grip" nil nil nil "--gfm" "--export" (buffer-file-name) "/tmp/grip.html")
    (let ((buf (current-buffer)))
      (eww-open-file "/tmp/grip.html")
      (switch-to-buffer buf)
      (pop-to-buffer "*eww*")))
  (define-key markdown-mode-map "\C-c\C-c\C-p" 'markdown-preview-by-eww)

  ;; (setq markdown-command "multimarkdown")
  ;; (setq markdown-command "pandoc -c ~/.pandoc/github-markdown.css")
  (setq markdown-command "grip --export")
  (setq markdown-enable-math t)
  )

(use-package eww
:ensure nil
  :defer t
  :custom
  (eww-auto-rename-buffer 'title)
  (eww-buffer-name-length 40)
  ;; :config
  )

;;

(use-package tramp
  :ensure nil
  :init
  (setq tramp-persistency-file-name "~/.emacs.d/.tramp")
  )

(use-package shrface
  :ensure t
  :if window-system
  :defer t
  :after (eww nov)
  :config
  (setq
    shr-image-animate nil    ;  Disable animation
    shr-use-fonts nil        ;  Don't use custom fonts
    shr-width     80         ;  Word wrap at 70 chars
    shr-hr-line   "-----"        ;  Character for an <hr/> line
    shr-indentation 2        ;  Left margin
    ;;   shr-cookie-policy t      ;  Always accept cookies
    shrface-href-versatile t
    )
  :hook (
          (eww-mode . shrface-mode)
          (nov-mode . shrface-mode)
          )
  )

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 15) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  )

(use-package consult
  :ensure t
  :after (migemo)
  :config
  (setq consult-async-refresh-delay 0.2)
  ;; @ref https://arialdomartini.github.io/consult-line-at-point
  (defun consult-line-symbol-at-point ()
    "Search for a line matching the symbol found near point."
    (interactive)
    (consult-line
      (or (thing-at-point 'symbol)))
    )
  ;; #TODO cmigemo
  :bind (
          ("C-x b" . consult-buffer)     ;; orig. switch-to-buffer
          ("C-x C-r" . consult-recent-file)
          ("C-x r b" . consult-bookmark)  ;; orig. bookmark-jump
          ("M-g g" . consult-goto-line)  ;; orig. goto-line
          ("M-g M-g" . consult-goto-line);; orig. goto-line
          ("C-s" . consult-line-symbol-at-point) ;; instead of consult-line
          ("C-r" . consult-line-symbol-at-point) ;; instead of consult-line
          ("C-c i" . consult-imenu)
          ("C-c I" . consult-imenu-multi)
          ("C-c l" . consult-locate)
          ("C-M-g" . consult-ripgrep)
          ("C-c g" . consult-ripgrep)
          ("C-M-y" . consult-yank-pop)
          ("C-c y" . consult-yank-pop)
          )
  )

(use-package consult-dir
  :ensure t
  :defer t
  :after consult
)

(use-package orderless
  :ensure t
  :config
  (with-eval-after-load 'minibuffer
    (setopt completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion)))))
  )

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode)
  )

(use-package embark
  :ensure t
  :defer t
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
  ;;                nil
  ;;                 (window-parameters (mode-line-format . none))))
  :bind  (
           ("C-." . embark-act)         ;; pick some comfortable binding
           ("C-;" . embark-dwim)        ;; good alternative: M-.
           ("C-h B" . embark-bindings) ;; alternative for `describe-bindings'
           )
  )

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :defer t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )

(use-package vterm
  :ensure t
  :defer t
  :custom
  (vterm-kill-buffer-on-exit t)
  (vterm-max-scrollback 10000)
  )

(use-package google-this
  :ensure t
  :bind
  ;; ("<f6>" . google-this-mode-submap)
  ("<f6>" . google-this-noconfirm)
  )

;;スペース、タブなどを可視化する;
;;(global - whitespace - mode 1)

;;(show-paren-mode t)
;; 括弧のハイライトの設定。mixed,parenthesis,expression
(setq show-paren-style 'mixed)
;; 選択範囲をハイライト
;;(transient-mark-mode t)

;;
;;Folding
;; cc-mode
(use-package emacs
  :ensure nil
  :config
  (add-hook 'c++-mode-hook '(lambda ()
                                      (hs-minor-mode 1)))
  (add-hook 'c-mode-hook '(lambda ()
                            (hs-minor-mode 1)))
  (add-hook 'emacs-lisp-mode-hook '(lambda ()
                                     (hs-minor-mode 1)))
  (add-hook 'lisp-mode-hook '(lambda ()
                               (hs-minor-mode 1)))
  (add-hook 'python-mode-hook '(lambda ()
                                 (hs-minor-mode 1)))
  (add-hook 'xml-mode-hook '(lambda ()
                              (hs-minor-mode 1)))
  (add-hook 'rust-mode-hook '(lambda ()
                               (hs-minor-mode 1)))
  ;; (bind-key "C-\\" 'hs-toggle-hiding c-mode-base-map)
  (bind-key "C-\\" 'hs-toggle-hiding)
)

;;
;;autoinsert-mode
(use-package emacs
  :ensure nil
  :init
  (auto-insert-mode 1)
  (setq auto-insert-query t) ;;; If you don't want to be prompted before insertion
  :hook (find-file-hooks . auto-insert)
  :config
  (setq auto-insert-alist
    (append '(
               (("\\.org\\'" . "org-mode template")
                 nil
                 "#+TITLE:"
                 (format-time-string "%Y/%m/%e(%a)")
                 " "
                 (file-name-nondirectory (buffer-file-name))
                 "\n"
                 "#+AUTHOR: Yuto TAGASHIRA\n"
                 "#+INFIX_OPT: view:t toc:t ltoc:t mouse:underline buttons:0 path:http://thomasf.github.io/solarized-css/org-info.min.js\n"
                 (format "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-light.min.css\" />\n")
                 "#+OPTIONS: ^:nil\n"
                 "#+OPTIONS: \\n:nil\n"
                 "#+OPTIONS: tex:t\n"
                 "#+options: auto-id:t"
                 "#+STARTUP: content"
                 "\n* Bookmark\n"
                 "\n* News\n"
                 "\n* Trivia\n"
                 > _
                 )
               ) auto-insert-alist))

  (setq auto-insert-alist
    (append '(
               (("\\.py\\'" . "python template")
                 nil
                 "#!/usr/bin/env python3\n"
                 "\n"
                 _
                 )
               ) auto-insert-alist))

  (setq auto-insert-alist
    (append '(
               (("\\.cpp\\'" . "cpp template")
                 nil
                 "/**\n"
                 "  @date Time-stamp: <2018-02-03 17:15:51 tagashira>\n"
                 "  @file "
                 (file-name-nondirectory (buffer-file-name))
                 "\n"
                 "  @brief\n"
                 "**/\n"
                 _
                 )
               ) auto-insert-alist))

  (setq auto-insert-alist
    (append '(
               (("\\.hpp\\'" . "hpp template")
                 nil
                 "/**\n"
                 "  @date Time-stamp: <2018-02-03 17:15:51 tagashira>\n"
                 "  @file "
                 (file-name-nondirectory (buffer-file-name))
                 "\n"
                 "  @brief\n"
                 "**/\n"
                 _
                 )
               ) auto-insert-alist))

  (setq auto-insert-alist
    (append '(
               (("\\.sh\\'" . "shellscript template")
                 nil
                 "#!/bin/bash\n"
                 "# @date Time-stamp: <2018-02-03 17:15:51 tagashira>\n"
                 "# @file "
                 (file-name-nondirectory (buffer-file-name))
                 "\n"
                 "# @brief\n"
                 "\n"
                 _
                 )
               ) auto-insert-alist))

  )

;;
;;shebangが付いているファイルのパーミッションを保存時に +x にしてくれる設定
(defun my-chmod-script()
  (interactive)
  (save-restriction (widen)
    (let ((name (buffer-file-name)))
      (if (and (not (string-match ":" name))
            (not (string-match "/\\.[^/]+$" name))
            (equal "#!" (buffer-substring 1 (min 3 (point-max)))))
        (progn (set-file-modes name (logior (file-modes name) 73))
          (message "Wrote %s (chmod +x)" name)
          ))
     )
    )
  )
(add-hook 'after-save-hook 'my-chmod-script)

;;
;; replace ten-maru to commma-period
(use-package emacs
  :ensure nil
  :defer t
  :config
  (defun my/replace-punctuation (a1 a2 b1 b2)
    (let ((s1 (if mark-active "selected region" "Buffer"))
           (s2 (concat a2 b2))
           (b (if mark-active (region-beginning) (point-min)))
           (e (if mark-active (region-end) (point-max))))
      (if (y-or-n-p (concat "Does " s1 " replace to " s2 "??"))
        (progn
          (replace-string a1 a2 nil b e)
          (replace-string b1 b2 nil b e)
          )
        )
      )
    )
  ;; (defun replace-punctuation-ten-to-maru ()
  ;;   "replace to [、。]"
  ;;   (interactive)
  ;;   (replace-punctuation "，" "、" "．" "。"))
  (defun my/replace-punctuation-comma-to-period ()
    "replace to [，．]"
    (interactive)
    (my/replace-punctuation "、" "，" "。" "．")
    )
  (defun my/replace-zenkaku-space-to-hankaku ()
    "replace [ ] to space"
    (interactive)
    (my/replace-punctuation "　" " " "　" " ")
    )
  (defun my/replace-zenkaku-paren-to-hankaku ()
    "replace （） to () "
    (interactive)
    (my/replace-punctuation "（" "(" "）" ")")
    )
  (defun my/replace-underline-to-hyphen ()
    "replace underline to hyphen"
    (interactive)
    (my/replace-punctuation "_" "-" "_" "-")
    )
  (defun my/replace-hyphen-to-underline ()
    "replace hypen to underline"
    (interactive)
    (my/replace-punctuation "-" "_" "-" "_")
    )
  ;; :hook (
  ;;         (before-save . my/replace-zenkaku-space-to-hankaku)
  ;;         (before-save . my/replace-zenkaku-paren-to-hankaku)
  ;;         )
  )

(use-package lsp-mode
  :if window-system
  :ensure t
  :commands lsp
  :after (yasnippet)
  :init
  (yas-global-mode)
  (add-to-list 'exec-path (expand-file-name "~/bin")) ;; rust-analyzer
  :hook ((rust-mode . lsp)
          (c-mode . lsp)
          (sh-mode . lsp)
          (bash-ts-mode . lsp)
          (typescript-mode . lsp)
          (html-mode . lsp)
          (css-mode . lsp)
          (js-mode . lsp)
          (dart-mode . lsp))
  :hook (before-save . lsp-format-buffer)
  :hook (lsp-mode . copilot-mode)
  ;; :bind ("C-c h" . lsp-describe-thing-at-point)
  :custom (lsp-rust-server 'rust-analyzer)
  (lsp-restart 'auto-restart)
  (lsp-headerline-breadcrumb-icons-enable nil)
  (lsp-lens-enable t)
  (lsp-signature-auto-activate t)
  (lsp-process-cleanup)
  ;; (setq
  ;; deno
  ;; lsp-clients-deno-enable-code-lens-references t
  ;; lsp-clients-deno-enable-code-lens-references-all-functions t
  ;; lsp-clients-deno-enable-lint t
  ;; lsp-clients-deno-enable-unstable nil
  ;; )
  :bind (
          ("<f2>" . 'lsp-rename)
          )
  )

(use-package lsp-ui
  :ensure t
  :defer t
  :custom
  ;; sideline
  (lsp-ui-sideline t)
  (lsp-ui-sideline-enable t)
  ;; lsp-ui-imenu
  (lsp-ui-imenu-auto-refresh t)
  :bind (:map lsp-mode-map
          ("<f12>" . 'lsp-ui-peek-find-definitions)
          ("<S-f12>" . 'lsp-ui-peek-find-references)
          )
  )



;;
;; cmake-mode
(use-package cmake-mode
  :ensure t
  :mode (
          ("CMakeLists\\.txt\\'" . cmake-mode)
          ("\\.cmake\\'" . cmake-mode)
          )
  )

;;
;; toml-mode
(use-package toml-mode
  :ensure t
  :mode (
          ("\\.toml\\'" . toml-mode)
          )
  )

;;
;; yaml mode
(use-package yaml-mode
  :ensure t
  :mode (
          ("\\.yml\\'" . yaml-mode)
          ("\\.yaml\\'" . yaml-mode)
          )
  )

;;
;;fish-mode
(use-package fish-mode
  :ensure t
  :config (setq fish-indent-offset 2)
  )

;;
;; csv-mode
(use-package csv-mode
  :ensure t
  :mode (
          ("\\.csv\\'" . csv-mode)
          )
  )

;;
;;python coding
(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq indent-tabs-mode nil
    indent-level 2
    ;; python-indent-offset 2
    python-indent 2
    tab-width 2
    ;; (define-key (current-local-map) "\C-h" 'python-backspace)
    )
  )

;;
;;company-jedi
(use-package epc
  :after (jedi-core)
  )

(use-package jedi-core
  :after (python)
  :config
  (setq jedi:complete-on-dot t)
  (setq jedi:use-shortcuts t)
  (add-to-list 'company-backends 'company-jedi) ; backendに追加
  :hook (python-mode-hook . jedi:setup)
  :config
  ;; PYTHONPATH上のソースコードがauto-completeの補完対象になる ;;;;;
  (setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
  (setenv "PYTHONPATH" "/usr/local/lib/python3.5/dist-packages")
  (setenv "PYTHONPATH" "~/.local/lib/python2.7/site-packages")
  (setenv "PYTHONPATH" "~/.local/lib/python3.5/site-packages")
  )

;;
;;py-autopep8
(use-package py-autopep8
  :ensure t
  :after (python)
  :config
  (setq py-autopep8-options '("--max-line-length=200" "--indent-size=2"))
  (setq flycheck-flake8-maximum-line-length 200)
  :hook (python-mode-hook . py-autopep8-enable-on-save)
  :bind (:map python-mode-map
          ("C-c C-q" . 'py-autopep8)
          )
  )
;;
;; ein
(use-package ein
  :if (display-graphic-p)
  :ensure t
  :config
  (setq
    jedi:complete-on-dot t
    ein:worksheet-enable-undo t
    ein:output-area-inlined-images t
    )

  :hook (
          ;; (ein:notebook-mode . jedi:setup)
          ;; (ein:notebook-mode . electric-pair-mode)
          (ein:notebook-mode . undo-tree-mode)
          )
  )

(use-package edit-indirect
  :ensure t
)

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :after (edit-indirect)
  :config
  (setopt markdown-fontify-code-blocks-natively t)
  (setopt markdown-header-scaling t)
  (setopt markdown-indent-on-enter 'indent-and-new-item)
  (setopt markdown-list-indent-width 2)
  (setopt markdown-enable-math t)
  (setopt markdown-enable-wiki-links t)
  :bind (
          ("C-}" . markdown-promote)
          ("C-{" . markdown-demote)
          )
  )

(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t)
  (rust-indent-offset 2)
  :config
  (add-to-list 'exec-path (expand-file-name "~/bin")) ;; rust-analyzer
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin")) ;; rustfmt,clippy,rust-analyzer
  )

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  )

(use-package cc-mode
  :ensure nil
  :config
  (setq-default c-basic-offset 2 tab-width 2 indent-tabs-mode nil)
  )

;;
;; multi-compile

(use-package clang-format
  :ensure t
  :init
  (setq clang-format-style-option "file")
  (defun my/enable-clang-format-on-save ()
    "現在のバッファ限定で before-save-hook に登録。"
    (interactive)
    (add-hook 'before-save-hook #'clang-format-buffer nil t)
    )
  :bind (:map c-mode-base-map
              ("C-c <down>" . clang-format-buffer)
              )
  )

(use-package multi-compile
  :ensure t
  :defer t
  :commands (multi-compile-run)
  :config
  (setq multi-compile-alist '((c++-mode . (("yukicoder test" . "yuki test %file-sans")
                                            ("yukicoder system" . "yuki sys %file-sans")
                                            ("yukicoder submit(quiet)" . "yuki subforce %file-sans")
                                            ("yukicoder commit" . "yuki commit %file-sans")
                                            ("AtCoder test" . "act test %file-sans")
                                            ("AtCoder system" . "act sys %file-sans")
                                            ("AtCoder submit(quiet)" . "act subforce %file-sans")
                                            ("AtCoder commit" . "act commit %file-sans")))))
  :bind (:map c-mode-base-map ("C-c C-c" . multi-compile-run))
  )

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

;;
;;shell
(setq sh-basic-offset 2)

;;
;;lisp
(setq lisp-indent-offset 2)


;;
;;visible-bell
(when (memq window-system '(mac ns))
  (setq visible-bell nil))


;;
;;point-undo.el
(use-package point-undo
  :ensure nil
  :defer t
  :load-path "site-lisp"
  :config (bind-key* "<f7>" 'point-undo)
  (bind-key* "C-<f7>" 'point-redo)
  )


;;
;; paredit.el
(use-package paredit
  :ensure t
  :defer t
  )

;;
;;eldoc
(use-package eldoc
  :defer t
  :ensure nil)

;;
;;eldoc-extention
;; (install-elisp-from-emacswiki "eldoc-extension.el")
(use-package eldoc-extension
  :defer t
  :ensure nil
  :load-path "site-lisp"
  :config (setq eldoc-idle-delay 0.01)
  (setq eldoc-echo-area-use-multiline-p t)
  :hook (emacs-lisp-mode . eldoc-mode)
  :hook (lisp-interaction-mode . eldoc-mode)
  :hook (ielm-mode . eldoc-mode))

;;
;;c-eldoc
(use-package c-eldoc
  :ensure t
  :defer t
  :config
  :hook (c-mode . c-turn-on-eldoc-mode)
  )

;;
;;session
(use-package session
  :disabled
  :ensure nil
  :init (setq history-length 10000)
  (setq session-initialize '(de-saveplace session keys menus places) session-globals-include '((kill-ring 50)
                                                                                                (session-file-alist 500 t)
                                                                                                (file-name-history 10000)))
  (setq session-undo-check -1)
  :hook (after-init session-initialize))

;;
;;undohist
(use-package undohist
  :ensure t
  :init (undohist-initialize)
  :custom
  (
    undohist-directory (expand-file-name "~/.emacs.d/.undohist")
    undohist-ignored-files '("/temp/" "/elpa" "elfeed"))
  )

;;
;;undo-tree
(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :bind (
          ("M-/" . undo-tree-redo)
          ("M-z" . undo-tree-undo)
          )
  :custom
  (
    undo-tree-auto-save-history nil undo-tree-visualizer-timestamps t
    ;; undo-tree-history-directory-alist '((expand-file-name "~/.emacs.d/.undo-tree"))
    undo-tree-visualizer-diff t)
  )

;;
;; treesit
(use-package treesit
  :ensure nil
  :config (setq treesit-font-lock-level 4)
  )

;;
;; tree-sitter
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)
  (setq treesit-auto-install t)
  (global-treesit-auto-mode)
  )

;;
;;company
(use-package company
  :disabled
  :ensure t
  :defer t
  :diminish company-mode
  :init   (global-company-mode 1) ; 全バッファで有効にする
  :config (setq company-idle-delay 0.01) ; デフォルトは0.5
  ;;(setq company-idle-delay nil);;手動補完
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-idle-delay nil) ; 自動補完をしない
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  (setq company-show-numbers t)   ;; Easy navigation to candidates with M-<n>
  (add-to-list 'company-backends 'company-files)
  :bind ("C-M-i" . company-complete)
  :bind (:map company-active-map ("C-n" . 'company-select-next )
          ("C-p" . 'company-select-previous)
          ("C-r" . 'company-filter-candidates)
          ("C-m" . 'company-complete-selection)
          ("C-i" . 'company-show-doc-buffer))
  :custom-face (flyspell-duplicate ((t (:foreground "white"
                                         :box nil
                                         :bold nil
                                         :underline nil))))
  (company-scrollbar-fg  ((t (:background "orange"))))
  (company-scrollbar-bg  ((t (:background "gray40")))))

;;volatile-highlights
(use-package volatile-highlights
  :ensure t
  :defer 30
  :config
  (volatile-highlights-mode t)
  )

;;docker.el
(use-package docker
  :ensure t
  :bind ("C-c d" . docker)
  )

(use-package dockerfile-mode
  :ensure t
  :commands dockerfile-mode
  :init (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))


;;
;; gtags
(use-package counsel-gtags
  :disabled
  :ensure t
  :init (counsel-gtags-mode 1)
  :config
  :hook (c-mode-hook . counsel-gtags-mode)
  :hook (c++-mode-hook . counsel-gtags-mode)
  :hook (python-mode-hook . counsel-gtags-mode)
  :bind (:map counsel-gtags-mode-map ("M-t" . 'counsel-gtags-find-definition) ;;入力されたタグの定義元へジャンプ
          ("M-r" . 'counsel-gtags-find-reference) ;;入力タグを参照する場所へジャンプ
          ("M-s" . 'counsel-gtags-find-symbol) ;;入力したシンボルを参照する場所へジャンプ
          ("M-," . 'counsel-gtags-go-backward) ;;ジャンプ前の場所に戻る
          ("M-." . 'counsel-gtags-go-forward)
          ("M-l" . 'counsel-gtags-dwim) ;;タグ一覧からタグを選択し, その定義元にジャンプする
          ))

;;
;;rtags
(use-package rtags
  :disabled
  :ensure nil
  :load-path "/opt/homebrew/Cellar/rtags/2.38/share/emacs/site-lisp/rtags/"
  :hook (c-mode . rtags-start-process-unless-running)
  :hook (c++-mode . rtags-start-process-unless-running)
  :config (setq rtags-completions-enabled t)
  (setq rtags-autostart-diagnostics t))

;;
;;company-rtags
(use-package company-rtags
  :disabled
  :ensure nil
  :load-path "/opt/homebrew/Cellar/rtags/2.38/share/emacs/site-lisp/rtags/")

;;
;; dart-mode
(use-package dart-mode
  :disabled
  :ensure t
  :defer t
  :mode ("\\.dart\\'" . dart-mode)
  :interpreter "dart"
  :custom (dart-format-on-save t)
  (dart-sdk-path "/opt/homebrew/bin/dart")
  :config
  ;; function run dart format on save
  (defun my/dart-fix-trailinkg-commas ()
    (interactive)
    (when (eq major-mode 'dart-mode)
      (message "Apply: dart fix --apply --code=require_trailing_commas")
      (call-process-shell-command "dart fix --apply --code=require_trailing_commas" nil 0)
      (call-process-shell-command "dart format ." nil 0)))
  :hook ((dart-mode . flycheck-mode)
          ;; (dart-mode . colilot-mode)
          (before-save . my/dart-fix-trailinkg-commas)))

(use-package lsp-dart
  :ensure t
  :defer t
  :custom (lsp-dart-enable-sdk-formatter t)
  ;; (lsp-dart-suggest-from-unimported-libraries nil)
  ;; (lsp-dart-main-code-lens nil)
  ;; (lsp-dart-flutter-widget-guides nil)
  (lsp-dart-test-tree-line-spacing 2)
  :bind (
          ("<f5>" . lsp-dart-run)
          )
  )

(add-to-list 'auto-mode-alist '("\\.nas\\'" . asm-mode))

;;
;; flutter.el
(use-package flutter
  :disabled
  :ensure t
  :defer t
  :after dart-mode
  :bind (:map dart-mode-map ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom (flutter-sdk-path "/opt/homebrew/bin/")
  ;; :hook (dart-mode . (lambda ()
  ;;                      (add-hook 'after-save-hook #'flutter-run-or-hot-reload nil t)
  ;;                      )
  ;;         )
  )

;;
;; copilot
(use-package copilot
  :disabled
  :ensure (:host github
            :repo "copilot-emacs/copilot.el"
            :branch "main"
            :depth 1
            :protocol https
            :files ("dist" "*.el"))
  :defer t
  :custom
  (copilot-node-executable "/opt/homebrew/bin/node")
  (copilot-indent-offset-warning-disable t)
  :bind (:map copilot-completion-map ("TAB" . copilot-accept-comletion)
          ("<tab>" . 'copilot-accept-completion)
          ("C-TAB" . 'copilot-accept-completion-by-word)
          ("C-<tab>" . 'copilot-accept-completion-by-word))
  :hook((emacs-lisp-mode . copilot-mode)))

;;ansi-color
(require 'ansi-color)
(add-hook 'compilation-filter-hook '(lambda ()
                                      (ansi-color-apply-on-region (point-min)
                                        (point-max))))

;; compile
(setq compilation-scroll-output t)

;;
;; typescript-mode
(use-package typescript-mode
  :ensure t
  :defer t
  :mode (("\\.ts\\'" . typescript-mode)
          ("\\.tsx\\'" . typescript-mode))
  :custom (typescript-indent-level 2))

;;
;; prettier
(use-package prettier-js
  :disabled
  :ensure t
  :config
  ;; (setq prettier-js-args '(
  ;;                           "--trailing-comma" "all"
  ;;                           "--bracket-spacing" "false"
  ;;                           ))
  (defun prettier-buffer ()
    (interactive)
    (shell-command (format "%s --write %s" (shell-quote-argument (executable-find "prettier"))
                     (shell-quote-argument (expand-file-name buffer-file-name))))
    (revert-buffer t t t))
  :hook (web-mode-hook . prettier-js-mode)
  :hook (web-mode-hook . (lambda ()
                           (add-hook 'after-save-hook 'my/prettier t t))))

;;
;;tide
(use-package tide
  :disabled
  :ensure t
  :defer t
  :after (typescript-mode)
  ;; :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
          (typescript-mode . tide-hl-identifier-mode)
          (before-save . tide-format-before-save)))

;;
;; js2-mode
(use-package js2-mode
  :disabled
  :ensure t
  :defer t
  :mode (("\\.js\\'" . js2-mode))
  :custom (js-indent-level 2))

;;
;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :defer t
  :after (cl-lib color)
  :config (cl-loop for index from 1 to rainbow-delimiters-max-face-count do (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
                                                                              (cl-callf color-saturate-name (face-foreground face) 30)))
  :hook (prog-mode-hook . rainbow-delimiters-mode))


;;
;;
(add-hook 'comint-exec-hook (lambda ()
                              (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nynil)))

(setq file-name-handler-alist my/saved-file-name-handler-alist)

(setq gc-cons-threshold 800000)
