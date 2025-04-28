(setq custom-file "~/.emacs.custom.el")
(load custom-file 'noerror)

(add-to-list 'default-frame-alist `(font . "Iosevka-14"))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 0)
(global-display-line-numbers-mode)

(ido-mode 0)

;; set encode format
(prefer-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
