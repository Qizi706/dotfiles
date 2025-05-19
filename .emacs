(setq custom-file "~/.emacs.custom.el")


;; use package
(require 'package)
(unless (bound-and-true-p package--initialized)
  (package-initialize))

(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

;; gruber-darker-theme
(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

;; expand-region
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;; markdown
(use-package markdown-mode
  :ensure t)

;; smartparens
(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config))

;; highlighting-parentheses
(use-package highlight-parentheses
  :ensure t
  :hook (prog-mode . highlight-parentheses-mode))

;; conda.el
(use-package conda
  :ensure t
  :init
  ;; set path/to/conda
  (setq conda-anaconda-home (expand-file-name "~/Programming/Env/miniconda3"))
  (setq conda-env-home-directory conda-anaconda-home)
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  ;; if using lsp-mode, also initialize it
  (conda-env-autoactivate-mode t))

;; projectfile
(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))


(load-file "~/.emacs.rc/rc.el")

;; basic config
(add-to-list 'default-frame-alist `(font . "IosevkaNerdFont-14"))
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(global-display-line-numbers-mode)
;; (rc/require-theme 'gruber-darker)


;; set encode format
(prefer-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; ido mode settings
(ido-mode 1)
(ido-everywhere 1)
(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c M-x") 'execute-extended-command)


(add-to-list 'load-path "~/.emacs.local/")


(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

;; multiple cursors
(rc/require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)


(load custom-file 'noerror)
