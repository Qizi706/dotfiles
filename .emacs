(package-initialize)

(setq custom-file "~/.emacs.custom.el")
(load-file "~/.emacs.rc/rc.el")

;; basic config
(add-to-list 'default-frame-alist `(font . "Iosevka-14"))
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 0)
(global-display-line-numbers-mode)
(rc/require-theme 'gruber-darker)


;; set encode format
(prefer-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; ido mode settings
(ido-mode 1)
(ido-everywhere 1)
(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


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


;; use package
;; (rc/require 'use-package)
;; (setq use-package-always-ensure t
;;       use-package-always-defer t
;;       use-package-enable-imenu-support t
;;       use-package-expand-minimally t)
;; 
;; ;; company config
;; (rc/require 'company)
;; (use-package company
;;   :hook (after-init . global-company-mode)
;;   :config (setq company-minimum-prefix-length 1
;;                 company-show-quick-access t))

(load custom-file 'noerror)
