;;; ivy-regexp-migemo.el ---
;;
;; https://tsuu32.hatenablog.com/entry/2020/09/22/234749
(require 'ivy)
(require 'migemo)

(defun my/migemo-get-pattern-shyly (word)
  (replace-regexp-in-string
   "\\\\("
   "\\\\(?:"
   (migemo-get-pattern word)))

(defun my/ivy--regex-migemo-pattern (word)
  (cond
   ((string-match "\\(.*\\)\\(\\[[^\0]+\\]\\)"  word)
    (concat (my/migemo-get-pattern-shyly (match-string 1 word))
            (match-string 2 word)))
   ((string-match "\\`\\\\([^\0]*\\\\)\\'" word)
    (match-string 0 word))
   (t
    (my/migemo-get-pattern-shyly word))))

(defun my/ivy--regex-migemo (str)
  (when (string-match-p "\\(?:[^\\]\\|^\\)\\\\\\'" str)
    (setq str (substring str 0 -1)))
  (setq str (ivy--trim-trailing-re str))
  (cdr (let ((subs (ivy--split str)))
         (if (= (length subs) 1)
             (cons
              (setq ivy--subexps 0)
              (if (string-match-p "\\`\\.[^.]" (car subs))
                  (concat "\\." (my/ivy--regex-migemo-pattern (substring (car subs) 1)))
                (my/ivy--regex-migemo-pattern (car subs))))
           (cons
            (setq ivy--subexps (length subs))
            (replace-regexp-in-string
             "\\.\\*\\??\\\\( "
             "\\( "
             (mapconcat
              (lambda (x)
                (if (string-match-p "\\`\\\\([^?][^\0]*\\\\)\\'" x)
                    x
                  (format "\\(%s\\)" (my/ivy--regex-migemo-pattern x))))
              subs
              ".*")
             nil t))))))

(defun my/ivy--regex-migemo-plus (str)
  (cl-letf (((symbol-function 'ivy--regex) #'my/ivy--regex-migemo))
    (ivy--regex-plus str)))

;;; Code:

(provide 'ivy-regexp-migemo)
;;; ivy-regexp-migemo.el ends here
