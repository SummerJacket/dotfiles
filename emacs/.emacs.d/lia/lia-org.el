;;; lia-org.el --- Part of my Emacs config

;;; Commentary:

;;

;;; Code:

(setq org-agenda-files '("~/Dropbox/org/") ; set agenda directory
      org-blank-before-new-entry '((heading) (plain-list-item)) ; blank lines between entries
      org-ellipsis " ⤵" ; custom ellipsis
      org-hide-emphasis-markers t ; hide formating characters
      org-log-done 'time ; add timestamps when task is done, or rescheduled
      org-log-redeadline 'time
      org-log-reschedule 'time)

;; org source code languages
(setq org-src-fontify-natively t)
(org-babel-do-load-languages
 'org-babel-load-languages '((css . t)
			     (emacs-lisp . t)
			     (java . t)
			     (js . t)
			     (latex . t)
			     (lisp . t)
			     (org . t)
			     (perl . t)
			     (python . t)
			     (ruby . t)
			     (sh . t)))

;; custom todo keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "ON HOLD(h)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")
	(sequence "[ ](T)" "[-](I)" "[*](W)" "|" "[X](D)")))

(provide 'lia-org)

;;; lia-org.el ends here
