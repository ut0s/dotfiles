;;
;;helm
(use-package helm
  :config
  (require 'helm-config)
  (helm-mode 1)

  :bind (("M-x"     . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x C-r" . helm-recentf)
         ("C-M-y"   . helm-show-kill-ring)
         ("C-c i"   . helm-imenu)
         ("C-x b"   . helm-buffers-list)
         ;; (bind-key* "M-r"     'helm-resume) ;;less usefull for me
         ;; (bind-key* "C-r"   'helm-occur) ;;switch helm-swoop interactive in 26-helm-swoop.el
         ("C-M-r" . isearch-backward) ;;default C-r isearch-backward
         ;; (bind-key* "C-c C-s" 'helm-surfraw)
         ;; (bind-key* "C-c C-g" 'helm-google-suggest)
         )

  :config
  (bind-key "C-h" 'delete-backward-char helm-map)
  (bind-key "C-h" 'delete-backward-char helm-find-files-map)
  (bind-key "TAB" 'helm-execute-persistent-action helm-find-files-map) ;; TABで補完
  ;; (bind-key "TAB" 'helm-execute-persistent-action helm-read-file-map)

  ;; (helm-autoresize-mode t)

  ;; optional fuzzy matching for helm-M-x
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match    t
        helm-ff-fuzzy-matching t
        helm-apropos-fuzzy-match t
        helm-lisp-fuzzy-completion t)


  (semantic-mode 1)
  (setq helm-semantic-fuzzy-match t
        helm-imenu-fuzzy-match    t)

  (setq helm-surfraw-default-browser-function 'browse-url-generic
        browse-url-generic-program "firefox")


  ;; Disable helm in some functions
  ;; (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
  ;; (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
  (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))
  (add-to-list 'helm-completing-read-handlers-alist '(find-tag . nil))

  (setq helm-buffer-details-flag nil)

  ;; Emulate `kill-line' in helm minibuffer
  (setq helm-delete-minibuffer-contents-from-point t)
  (defadvice helm-delete-minibuffer-contents (before emulate-kill-line activate)
    "Emulate `kill-line' in helm minibuffer"
    (kill-new (buffer-substring (point) (field-end))))

  (defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-file-exist activate)
    "Execute command only if CANDIDATE exists"
    (when (file-exists-p candidate)
      ad-do-it))

  (defadvice helm-ff--transform-pattern-for-completion (around my-transform activate)
    "Transform the pattern to reflect my intention"
    (let* ((pattern (ad-get-arg 0))
           (input-pattern (file-name-nondirectory pattern))
           (dirname (file-name-directory pattern)))
      (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
      (setq ad-return-value
            (concat dirname
                    (if (string-match "^\\^" input-pattern)
                        ;; '^' is a pattern for basename
                        ;; and not required because the directory name is prepended
                        (substring input-pattern 1)
                      (concat ".*" input-pattern))))))

  (defun helm-buffers-list-pattern-transformer (pattern)
    (if (equal pattern "")
        pattern
      (let* ((first-char (substring pattern 0 1))
             (pattern (cond ((equal first-char "*")
                             (concat " " pattern))
                            ((equal first-char "=")
                             (concat "*" (substring pattern 1)))
                            (t
                             pattern))))
        ;; Escape some characters
        (setq pattern (replace-regexp-in-string "\\." "\\\\." pattern))
        (setq pattern (replace-regexp-in-string "\\*" "\\\\*" pattern))
        pattern)))


  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
  (add-to-list 'helm-source-buffers-list
               '(pattern-transformer helm-buffers-list-pattern-transformer))

  (defadvice helm-ff-sort-candidates (around no-sort activate)
    "Don't sort candidates in a confusing order!"
    (setq ad-return-value (ad-get-arg 0)))


  ;;helm-recentf
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 20000)
  (setq recentf-auto-cleanup t)
  (setq recentf-exclude '("/.recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)


  ;;popup.elをhelm化する
  (defun popup-menu*--helm (selection &rest ignore)
    (helm-comp-read "Popup menu: " selection :must-match t))
  (advice-add 'popup-menu* :override 'popup-menu*--helm)

  ;; helm mini
  ;; (bind-key* "C-c C-r" 'helm-mini)
  ;; (custom-set-variables
  ;;  '(helm-mini-default-sources '(helm-source-buffers-list
  ;;                                helm-source-ls-git-status
  ;;                                helm-source-files-in-current-dir
  ;;                                helm-source-ls-git
  ;;                                helm-source-recentf
  ;;                                helm-source-ghq)))


  ;; search function,variables in helm
  ;; Helmのコマンド・関数・変数などなどEmacsのありとあらゆるオブジェクトのマニュアルを参照
  (bind-key* "C-M-h" 'helm-apropos)

  ;; helm-man-woman
  ;; (bind-key* "" 'helm-man-woman)
  (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
  )


