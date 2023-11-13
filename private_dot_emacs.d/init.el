(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; (package-refresh-contents) ;; only to update

;; disable splash screen
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

;; hide warning
(setq warning-minimum-level :error)

;; utf-8
(prefer-coding-system 'utf-8)

;; hide lockfiles
(setq-default lock-file-name-transforms
              `((".*" ,(expand-file-name "~/.emacs.d/lockfiles") t)))

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
(add-hook 'eshell-mode-hook (lambda () (display-line-numbers-mode 0)))

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
(add-hook 'treemacs-mode-hook
	  (lambda ()
	    (display-line-numbers-mode 0)
	    (set-face-background 'hl-line "black")))

;; word wrap
(add-hook 'text-mode-hook #'auto-fill-mode)
(setq-default fill-column 80)

;; indentation
(setq indent-tabs-mode nil)
(setq tab-width 2)

;; markdown config
(unless (package-installed-p 'markdown-mode)
  (package-install 'markdown-mode))
(setq markdown-enable-wiki-links 't)
(unless (package-installed-p 'polymode)
  (package-install 'poly-markdown))
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;; nix config
(unless (package-installed-p 'nix-mode)
  (package-install 'nix-mode))
(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

;; powershell config
(unless (package-installed-p 'powershell)
  (package-install 'powershell))
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))

;; dotfiles management
(unless (package-installed-p 'chezmoi)
  (package-install 'chezmoi))
(require 'chezmoi)
(general-define-key
 :states 'normal
 :prefix ";"
 "cf" #'chezmoi-find)
(general-define-key
 :states 'normal
 :prefix ";"
 "cs" #'chezmoi-write)

;; magit
(unless (package-installed-p 'magit)
  (package-install 'magit))
(require 'magit)
(general-define-key
 :states 'normal
 :prefix ";"
 "m" 'magit)

;; bar
(unless (package-installed-p 'telephone-line)
  (package-install 'telephone-line))
(require 'telephone-line)
(setq telephone-line-primary-left-separator 'telephone-line-flat
      telephone-line-secondary-left-separator 'telephone-line-flat
      telephone-line-primary-right-separator 'telephone-line-flat
      telephone-line-secondary-right-separator 'telephone-line-flat)
(telephone-line-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(poly-markdown nix-mode general evil-collection markdown-preview-mode markdown-mode ample-theme evil-smartparens smartparens-config centered-cursor-mode evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
