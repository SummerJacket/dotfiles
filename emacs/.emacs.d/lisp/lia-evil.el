;;; lia-evil.el --- Emacs Config -*- lexical-binding: t; -*-

;;; Commentary:

;; anything evil-mode related goes here

;;; Code:

(use-package evil
  :ensure t
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-keybinding nil)
  (setq evil-search-module 'evil-search))

(use-package evil-collection
  :ensure t
  :after (evil)
  :config (evil-collection-init))

(use-package evil-surround
  :ensure t
  :after (evil))

(use-package evil-magit
  :after (evil magit))

(use-package evil-mc
  :ensure t
  :after (evil)
  :config (global-evil-mc-mode 1))

(provide 'lia-evil)

;;; lia-evil.el ends here
