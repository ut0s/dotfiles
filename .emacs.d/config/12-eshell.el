;; 12-eshell.el

(use-package eshell
  :straight nil
  :config
  ;;
  ;; alias
  (setq eshell-command-aliases-list
	(append
	 (list
	  (list "rm" "rm -iv")
	  (list "cp" "cp -iv")
	  (list "mv" "mv -iv")
	  (list "scp" "scp -Cpr")
	  ;; ls
	  (list "ll" "ls -alFh --color=auto")
	  (list "la" "ls -Ah --color=auto")
	  (list "l" "ls -CFh --color=auto")
	  (list "sl" "ls -CFh --color=auto")
	  ;;color
	  (list "less" "less -R")
	  (list "grep" "grep --color")
	  ;; disk size
	  (list "du" "du -hT")
	  ;;git
	  (list "g" "git")
	  (list "ga" "git add")
	  (list "gb" "git branch")
	  (list "gd" "git diff")
	  (list "gs" "git status")
	  (list "gst" "git status")
	  (list "gis" "git status")
	  (list "gits" "git status")
	  (list "gf" "git fetch")
	  (list "gc" "git commit")
	  (list "pull" "git pull")
	  (list "push" "git push")
	  ;; dotfiles	
	  (list "dots" "cd ~/dotfiles")
	  ;; trash-cli
	  (list "rm" "trash-put")
	  (list "rng" "ranger")
	  ;; open in emacs 
	  (list "emacs" "find-file $1")
	  ;; dired
	  (list "d" "dired .")
	  )))

  (defun eshell/make-new-eshell ()
    "Create a shell buffer."
    (interactive)
    (setq name (format "DEV:%s" (random 256)))
    (eshell)
    (rename-buffer name)
    )

  (defun eshell/rename-buffer (name)
    "Rename eshell buffer named NAME."
    (interactive "sName: ")
    (setq name (format "DEV:%s" name))
    (rename-buffer name)
    )

  (defun eshell/move-buffer-prev ()
    "Move previous eshell buffer."
    (interactive)
    (setq re "#<buffer DEV:[a-Z0-9]+>")
    (message (string-match re (format "%s" (buffer-list))))
    )

  (defun eshell/move-buffer-next ()
    "Move next eshell buffer."
    (interactive)
    (list-buffers)
    )

  :bind ( ("C-M-t" . eshell/make-new-eshell)
          ("C-x ," . eshell/rename-buffer)
          ;; ("C-[" . eshell/move-buffer-prev)
          ;; ("C-]" . eshell/move-buffer-next)
          )
  )
