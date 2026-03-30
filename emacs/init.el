(setq inhibit-startup-message nil)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(global-display-line-numbers-mode 'relative)
(setq display-line-numbers 'relative)
(dolist (mode '(term-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(require 'use-package)
(setq use-package-always-ensure nil)

(set-face-attribute 'default nil :font "Fira Code" :height 120)

(use-package emacs
  :custom
  (tab-always-indent 'complete)
  
  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)
  
  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

(use-package exwm
  :config
  ;; Set the initial workspace number.
  (setq exwm-workspace-number 4)
   ;; Make class name the buffer name.
  (add-hook 'exwm-update-class-hook
	    (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
   ;; Global keybindings.
  (setq exwm-input-global-keys
	`(([?\s-r] . exwm-reset)  ;;s-r: Reset (to line-mode).
          ([?\s-w] . exwm-workspace-switch)  ;;s-w: Switch workspace.
          ([?\s-&] . (lambda (cmd)  ;;s-&: Launch application.
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command cmd nil cmd)))
           ;; s-N: Switch to certain workspace.
         ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
			(lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
   ;; Enable EXWM
  (exwm-wm-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-minibuffer t) 
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  ;; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; (evil-set-initial-state 'minibuffer-mode 'normal)
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  )

(use-package general
  :after evil
  :config
  (general-evil-setup t))

(general-create-definer my/leader-keys
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

(my/leader-keys
  "u" '(universal-argument :which-key "C-u"))

(use-package vertico
  :general
  (:states '(normal insert motion emacs) :keymaps 'vertico-map
	   "<escape>" #'minibuffer-keyboard-quit
	   "C-J"      #'vertico-next-group
	   "C-K"      #'vertico-previous-group
	   "C-j"      #'vertico-next
	   "C-k"      #'vertico-previous
	   "M-RET"    #'vertico-exit)
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t) ;; Emacs 31: partial-completion behaves like substring
  )

(use-package marginalia
  :after vertico
  :config
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-auto t)
  :hook ((prog-mode . corfu-mode))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  )

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-gruvbox t))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))
