;;; lia-packages.el --- Part of my Emacs config

;;; Commentary:

;; This file installs and configures the packages that I personally use

;;; Code:

;; add package repos
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; always install
(setq use-package-always-ensure t)


;; EVIL MODE
;; essentially, emacs is now vim
(use-package evil
  :init
  ;; Scroll up with C-u
  (setq evil-want-C-u-scroll t)
  :config
  ;; move by visual line
  (evil-global-set-key 'motion (kbd "j") 'evil-next-visual-line)
  (evil-global-set-key 'motion (kbd "k") 'evil-previous-visual-line)

  ;; leader key
  (use-package evil-leader
    :config
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")

    (evil-leader/set-key
      ","   'other-window
      "."   'mode-line-other-buffer
      "SPC" 'lia/window-switch-split
      "w"   'lia/window-swap
      "c"   'comment-region
      "s"   'eshell
      "a"   'evil-numbers/inc-at-pt
      "x"   'evil-numbers/dec-at-pt
      "f"   'helm-find-files
      "e"   'flycheck-next-error
      "b"   'helm-mini
      "d"   'kill-this-buffer
      "g"   'magit-status
      "n"   'neotree-toggle
      "l"   'nlinum-mode
      "r"   'nlinum-relative-toggle
      "t"   'org-agenda
      ))

  ;; multiple cursors for evil
  (use-package evil-mc
    :diminish evil-mc-mode
    :config
    (global-evil-mc-mode 1))

  ;; use magit with evil keys
  (use-package evil-magit)

  ;; increment/decrement numbers
  (use-package evil-numbers
    :init
    (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt))

  ;; evil keys in org mode
  (use-package evil-org
    :diminish evil-org-mode
    :config
    (add-hook 'org-mode-hook 'evil-org-mode)
    (add-hook 'evil-org-mode-hook
	      (lambda ()
		(evil-org-set-key-theme)))
    (evil-define-key 'emacs org-agenda-mode-map
      "j" 'evil-next-line
      "k" 'evil-previous-line))
  
  ;; vim surround
  (use-package evil-surround
    :config
    (global-evil-surround-mode t)))


;; always keep code indented nicely
(use-package aggressive-indent
  ;;:diminish aggressive-indent-mode
  :config
  (global-aggressive-indent-mode t)
  (add-to-list 'aggressive-indent-excluded-modes 'python-mode))

;; ICONS!
(use-package all-the-icons)

;; icons in dired
(use-package all-the-icons-dired
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; base16 colours
(use-package base16-theme
  :config
  (load-theme 'base16-ocean t)
  (defvar lia/base16-colors base16-ocean-colors
    "It's nice to have some colour")

  ;; https://github.com/belak/base16-emacs#evil-mode
  ;; Set the cursor color based on the evil state
  (setq evil-emacs-state-cursor   `(,(plist-get lia/base16-colors :base0D) box)
	evil-insert-state-cursor  `(,(plist-get lia/base16-colors :base0D) bar)
	evil-motion-state-cursor  `(,(plist-get lia/base16-colors :base0E) box)
	evil-normal-state-cursor  `(,(plist-get lia/base16-colors :base0B) box)
	evil-replace-state-cursor `(,(plist-get lia/base16-colors :base08) hbar)
	evil-visual-state-cursor  `(,(plist-get lia/base16-colors :base09) box)))

;; swap windows (buffers)
(use-package buffer-move
  :config
  (evil-global-set-key 'motion (kbd "C-S-h") 'buf-move-left)
  (evil-global-set-key 'motion (kbd "C-S-j") 'buf-move-down)
  (evil-global-set-key 'motion (kbd "C-S-k") 'buf-move-up)
  (evil-global-set-key 'motion (kbd "C-S-l") 'buf-move-right))


;; text completion
(use-package company
  :diminish company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; a better startup screen
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Now with 40% more flavor!"
	dashboard-startup-banner 'logo
	dashboard-items '((recents . 10)
			  (bookmarks .10)
			  (projects . 10)
			  (agenda . 10))))

;; hide or shorten minor modes
(use-package diminish
  :config
  (diminish 'visual-line-mode)
  (diminish 'auto-revert-mode)
  (diminish 'undo-tree-mode))

;; syntax checking
(use-package flycheck
  :diminish flycheck-mode
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; fold marked regions
(use-package folding
  :disabled
  :init
  (load "folding" 'nomessage 'noerror)
  (folding-mode-add-find-file-hook)
  :config
  (folding-add-to-marks-list 'web-mode "<!-- {{{ " "<!-- }}} -->" " -->" nil t))

;; show git changes in gutter
(use-package git-gutter-fringe
  :diminish git-gutter-mode
  :init
  (global-git-gutter-mode t)
  (setq fringes-outside-margins t)
  :config
  (set-face-foreground 'git-gutter-fr:added    (plist-get lia/base16-colors :base0B))
  (set-face-foreground 'git-gutter-fr:modified (plist-get lia/base16-colors :base0A))
  (set-face-foreground 'git-gutter-fr:deleted  (plist-get lia/base16-colors :base08))
  ;; https://github.com/hlissner/.emacs.d/blob/master/core/core-vcs.el#L24
  (define-fringe-bitmap 'git-gutter-fr:added
    [224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
    nil nil 'center)
  (define-fringe-bitmap 'git-gutter-fr:modified
    [224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
    nil nil 'center)
  (define-fringe-bitmap 'git-gutter-fr:deleted
    [224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224 224]
    nil nil 'center))

;; narrow lists
(use-package helm
  :diminish helm-mode
  :init
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x))

;; helm integration with projectile
(use-package helm-projectile
  :config
  (helm-projectile-on))

;; java add-on
(use-package jdee
  :disabled)

;; git
(use-package magit
  :config

  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session))

;; Ever heard of NERDTREE? Basically that.
(use-package neotree
  :config
  (setq neo-smart-open t
	projectile-switch-project-action 'neotree-projectile-action
	neo-window-fixed-size nil
	neo-theme (if (display-graphic-p) 'icons 'arrow))

  ;; change neotree's text colours
  ;; oh boy, here we go.
  (set-face-attribute 'neo-banner-face nil
		      :foreground (plist-get lia/base16-colors :base0C))

  (set-face-attribute 'neo-header-face nil
		      :foreground (plist-get lia/base16-colors :base05))

  (set-face-attribute 'neo-root-dir-face nil
		      :foreground (plist-get lia/base16-colors :base0C))

  (set-face-attribute 'neo-dir-link-face nil
		      :foreground (plist-get lia/base16-colors :base0D))

  (set-face-attribute 'neo-file-link-face nil
		      :foreground (plist-get lia/base16-colors :base05))

  (set-face-attribute 'neo-expand-btn-face nil
		      :foreground (plist-get lia/base16-colors :base0C))

  (set-face-attribute 'neo-vc-default-face nil
		      :foreground (plist-get lia/base16-colors :base05))

  (set-face-attribute 'neo-vc-user-face nil
		      :foreground (plist-get lia/base16-colors :base08))

  (set-face-attribute 'neo-vc-up-to-date-face nil
		      :foreground (plist-get lia/base16-colors :base03))

  (set-face-attribute 'neo-vc-edited-face nil
		      :foreground (plist-get lia/base16-colors :base0E))

  (set-face-attribute 'neo-vc-needs-merge-face nil
		      :foreground (plist-get lia/base16-colors :base08))

  (set-face-attribute 'neo-vc-unlocked-changes-face nil
		      :foreground (plist-get lia/base16-colors :base08))

  (set-face-attribute 'neo-vc-added-face nil
		      :foreground (plist-get lia/base16-colors :base0B))

  (set-face-attribute 'neo-vc-conflict-face nil
		      :foreground (plist-get lia/base16-colors :base08))

  (set-face-attribute 'neo-vc-missing-face nil
		      :foreground (plist-get lia/base16-colors :base08))

  (set-face-attribute 'neo-vc-ignored-face nil
		      :foreground (plist-get lia/base16-colors :base03))

  (global-set-key [f8] 'neotree-toggle)

  ;; http://nadeemkhedr.com/emacs-tips-and-best-plugins-to-use-with-evil-mode/#neotreelinkhttpsgithubcomjaypeiemacsneotree
  (setq projectile-switch-project-action 'neotree-projectile-action)
  (evil-define-key 'normal neotree-mode-map
    (kbd "q") 'neotree-hide
    (kbd "h") 'neotree-hidden-file-toggle
    (kbd "z") 'neotree-stretch-toggle
    (kbd "R") 'neotree-refresh
    (kbd "m") 'neotree-rename-node
    (kbd "c") 'neotree-create-node
    (kbd "d") 'neotree-delete-node
    (kbd "SPC") 'neotree-quick-look
    (kbd "TAB") 'neotree-enter
    (kbd "RET") 'neotree-enter))

;; linum is laggy. use nlinum instead
(use-package nlinum
  :config
  ;; Preset `nlinum-format' for minimum width.
  ;; https://www.emacswiki.org/emacs/LineNumbers#toc6
  (defun lia/nlinum-mode-hook ()
    (when nlinum-mode
      (setq-local nlinum-format
		  (concat " %" (number-to-string
				;; Guesstimate number of buffer lines.
				(ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
			  "d "))))
  (add-hook 'nlinum-mode-hook #'lia/nlinum-mode-hook))

;; relative line numbers
(use-package nlinum-relative
  :config
  (setq nlinum-relative-current-symbol ""
	nlinum-relative-redisplay-delay 0)

  (nlinum-relative-setup-evil)
  ;;(add-hook 'prog-mode-hook 'nlinum-relative-mode)
  )

;; cool looking bullets in org
(use-package org-bullets
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-bullets-bullet-list '("•")))

;; page break lines
(use-package page-break-lines
  :diminish page-break-lines-mode)

;; powerline
(use-package powerline
  :config
  (setq powerline-default-separator 'slant
  	powerline-height 30)

  (set-face-attribute 'powerline-active1 nil
		      :foreground (plist-get lia/base16-colors :base05)
		      :background (plist-get lia/base16-colors :base01))

  (set-face-attribute 'powerline-active2 nil
		      :background (plist-get lia/base16-colors :base01))

  (set-face-attribute 'powerline-inactive1 nil
		      :foreground (plist-get lia/base16-colors :base03)
		      :background (plist-get lia/base16-colors :base01)))

;; features for projects
(use-package projectile
  :config
  (projectile-mode t)
  ;; https://github.com/sviridov/.emacs.d/blob/master/config/base/init-diminish.el#L25
  (setq-default projectile-mode-line
		'(:eval (format "Pro[%s]" (projectile-project-name)))))

;; rainbow brackets
(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package smooth-scrolling
  :config
  (smooth-scrolling-mode t))

;; modeline from spacemacs
(use-package spaceline
  :config
  (require 'spaceline-config)

  (setq spaceline-minor-modes-separator " "
	spaceline-separator-dir-left '(right . right)
	spaceline-separator-dir-right '(right . right)
	spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)

  (eval
   `(defface lia/mode-line-face
      '((t :foreground ,(plist-get lia/base16-colors :base05)
	   :background ,(plist-get lia/base16-colors :base02)
	   :inherit 'mode-line))
      "Custom mode line face"
      :group 'spaceline))

  ;; https://github.com/TheBB/spaceline/blob/e6ccec6c80ee2bbddbad5a88cb9d2cd2db8a1a33/spaceline.el#L122
  (setq spaceline-face-func
  	(lambda (face active)
  	  (cond
  	   ((eq 'face1 face) (if active 'powerline-active1 'powerline-inactive1))
  	   ((eq 'face2 face) (if active 'lia/mode-line-face 'powerline-inactive1))
  	   ((eq 'line face) (if active 'powerline-active2 'powerline-inactive1))
  	   ((eq 'highlight face) (if active
  				     (funcall spaceline-highlight-face-func)
  				   'powerline-inactive1)))))

  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-size-off)
  (spaceline-spacemacs-theme)

  (use-package spaceline-all-the-icons
    :disabled
    :config
    (spaceline-all-the-icons-theme)
    (spaceline-all-the-icons--setup-neotree)))

;; make the editor more sublime-y
(use-package sublimity
  :disabled
  :config
  ;;(require 'sublimity-map)
  (require 'sublimity-scroll)
  (sublimity-mode t))

;; neat features for web development
(use-package web-mode
  :disabled)

;; templates
(use-package yasnippet
  ;;:diminish yas-minor-mode
  :config
  (yas-global-mode t))

;; yasnippet collection
(use-package yasnippet-snippets)

(provide 'lia-packages)

;;; lia-packages.el ends here
