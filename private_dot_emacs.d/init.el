(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; (package-refresh-contents) ;; only to update

;; disable splash screen
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

;; utf-8
(prefer-coding-system 'utf-8)

;; vim mode
(unless (package-installed-p 'evil)
  (package-install 'evil))
(setq evil-want-keybinding nil)
(require 'evil)
(evil-mode 1)
(setq evil-vsplit-window-right t)
(setq evil-split-window-below t)

(unless (package-installed-p 'general)
  (package-install 'general))
(require 'general)

(define-key evil-normal-state-map (kbd "C-<return>") 'previous-buffer)

(unless (package-installed-p 'evil-collection)
  (package-install 'evil-collection))
(evil-collection-init)

;; hide UI elements
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; relative line number
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)


;; center cursor horizontally
(unless (package-installed-p 'centered-cursor-mode)
  (package-install 'centered-cursor-mode))
(global-centered-cursor-mode)

;; parenthesis, brackets etc. autocomplete
(unless (package-installed-p 'smartparens)
  (package-install 'smartparens))
(require 'smartparens)
(smartparens-global-mode)

(unless (package-installed-p 'evil-smartparens)
  (package-install 'evil-smartparens))
(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)

;; color theme
(unless (package-installed-p 'ample-theme)
  (package-install 'ample-theme))
(load-theme 'ample t t)
(enable-theme 'ample)

;; disable line number in terminal mode
(add-hook 'term-mode-hook (lambda () (display-line-numbers-mode 0)))
(add-hook 'treemacs-mode-hook
	  (lambda ()
	    (display-line-numbers-mode 0)
	    (set-face-background 'hl-line "black")))


;; directory tree
(unless (package-installed-p 'treemacs)
  (package-install 'treemacs))
(require 'treemacs)
(unless (package-installed-p 'treemacs-evil)
  (package-install 'treemacs-evil))
(require 'treemacs-evil)
(general-define-key
 :states 'normal
 :prefix ";"
 "t" 'treemacs)

;; markdown config
(unless (package-installed-p 'markdown-mode)
  (package-install 'markdown-mode))
(setq markdown-enable-wiki-links 't)
;; nix config
(unless (package-installed-p 'nix-mode)
  (package-install 'nix-mode))
(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(nix-mode treesit-auto tree-sitter-langs general evil-collection markdown-preview-mode markdown-mode ample-theme evil-smartparens smartparens-config centered-cursor-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
