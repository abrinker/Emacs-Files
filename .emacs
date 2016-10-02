;;; package --- Summary;
;;; Commentary:
;; Alex's .emacs file
;; June 9 2016

;; Note: To exclude Emacs stuff from git use the following in .git/info/exclude
;; ### Emacs ###
;; *~
;; \#*\#
;; .\#*

;; Note: To make terminal shortcuts, just edit ~/.bash_profile

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;===================== Alex Additions ========================;

;; Gets rid of the startup screen
(setq inhibit-startup-message t)

;; Set higlighting modes for certain files
(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))

;; disables tabs in place of spaces
(setq-default indent-tabs-mode nil)

;; This may work better?
(setq-default tab-width 2)
(setq tab-width 2)
(setq standard-indent 2)
(setq indent-line-function 'insert-tab)

;; sets tabs to 2 spaces
(setq-default c-basic-offset 4)
(setq-default ruby-basic-offset 2)
(setq-default css-basic-offset 2)
(setq-default css-indent-offset 2)
(setq-default scss-basic-offset 2)
(setq-default js-basic-offset 2)
(setq-default js-indent-level 2)
(add-hook 'java-mode-hook (lambda() (setq tab-width 4)))
(add-hook 'js-mode-hook (lambda() (setq tab-width 2)))

;; disables annoying automatic tabbing
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Don't allow tab to only indent
(setq-default c-tab-always-indent nil)

;; syntax highlighting by default
(global-font-lock-mode 1)

;; always truncate lines pls and ty
(set-default 'truncate-lines t)

;; Also who even uses scroll bars?
(scroll-bar-mode -1)

;; Scroll down with the cursor,move down the buffer one
;; line at a time, instead of in larger amounts.
(setq scroll-step 1) ;; Keyboard scroll
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-follow-mouse 't)

;; move backup files to a separate directory
(setq backup-directory-alist '(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 5
      kept-old-versions 5
      version-control t)

;; Set Shift-TAB to force tabs
(setq tab-stop-list '(2 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
(global-unset-key (kbd "<S-tab>"))
(global-set-key (kbd "<S-tab>") 'tab-to-tab-stop)

;; Configures some stock state variables for editing
(which-function-mode 1)

;; Shows trailing whitespace
;; I hate lint
(setq-default show-trailing-whitespace t)
(add-hook 'prog-mode-hook (lambda() (setq show-trailing-whitespace t)))
(add-hook 'css-mode-hook (lambda() (setq show-trailing-whitespace t)))

;; shows the column number in the mod line
(column-number-mode t)

;; Set hotkey for mass commenting/uncommenting
(global-set-key (kbd "s-/") 'comment-dwim)

;; Make it easier to close windows
(global-set-key (kbd "s-<escape>") 'delete-window)

;; Set hotkeys for navigating by paragraph to up and down arrows
(global-set-key (kbd "M-<down>") 'forward-paragraph)
(global-set-key (kbd "M-<up>") 'backward-paragraph)

;; Stop the pesky ctrl-z binding from killing emacs
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
;; Now rebind ctrl-z to undo things
(global-set-key (kbd "C-z") 'undo)

;; Bind cmd-arrows to switch buffers
(global-unset-key (kbd "s-<left>"))
(global-unset-key (kbd "s-<right>"))
(global-set-key (kbd "s-<left>") 'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)
(global-set-key (kbd "s-<up>") 'windmove-up)
(global-set-key (kbd "s-<down>") 'windmove-down)

;; Stop my fat fingers from doint the wrong thing
;; I can't hit ctrl-e...only mod-e :(
(global-unset-key (kbd "M-e"))
(global-set-key (kbd "M-e") 'move-end-of-line)

;; Stop kill paragraph, instead implement kill word
(global-unset-key (kbd "M-k"))
(global-set-key (kbd "M-k") 'kill-word)

;; Always end a file with a newline
(setq require-final-newline nil)

;; Replace highlighted text instead of just inserting before
(delete-selection-mode 1)

;; Skeleton of ranger. Replace it with something better
(global-unset-key (kbd "C-x C-d"))

;; This Used to be vim
(global-unset-key (kbd "C-c C-u"))
(global-unset-key (kbd "C-c C-d"))

;; Also, why not save history? (So I can locate files I was working on previously)
(savehist-mode 1)

;; Show lines when going to a specific line
(global-set-key [remap goto-line] 'goto-line-with-feedback)

;;======================== Functions ==========================;

;; fullscreen on F11
(defvar old-fullscreen)
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                       (if (equal 'fullboth current-value)
                           (if (boundp 'old-fullscreen) old-fullscreen nil)
                         (progn (setq old-fullscreen current-value)
                                'fullboth)))))
(global-set-key [f12] 'toggle-fullscreen)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively 'goto-line))
    (linum-mode -1)))

;; Switch to Minibuffer
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
   (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))
(global-set-key (kbd "C-x o") 'switch-to-minibuffer)

(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "C-c C-k") 'copy-line)

;;======================== Packages ===========================;

; Initialize package.el, our package manager
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-enable-at-startup nil) ; Don't initialize twice
  (add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/") t)
)

;; Initialize (load if not available) our package organizer
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; clean-aindent-mode
(use-package clean-aindent-mode
  :init (add-hook 'prog-mode-hook 'clean-aindent-mode)
  :config (electric-indent-mode -1)
          (clean-aindent-mode t)
          (setq clean-aindent-is-simple-indent t)
          (define-key global-map (kbd "RET") 'newline-and-indent))

;; Butler shall clean up my whitespace on-save
(use-package ws-butler
  :config (add-hook 'prog-mode-hook 'ws-butler-mode)
          (add-hook 'css-mode-hook 'ws-butler-mode))

;; Auto-Complete package I love auto complete
(use-package auto-complete-config
  :config (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
          (ac-config-default)
          ;; Disable autocomplete on a RET key
          (define-key ac-completing-map "\r" nil)
          (ac-set-trigger-key "TAB")
          (setq ac-auto-start 3))

;; Lint checking! (WIP here, It's not perfect)
(use-package flycheck
  :bind ("C-c c" . flycheck-clear)
  :config (add-hook 'after-init-hook #'global-flycheck-mode)
          (flycheck-add-mode 'javascript-eslint 'web-mode))

;; Indent Guide
(use-package indent-guide
  :config (indent-guide-global-mode))

;; Rainbow Delimiters!
(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Web-Mode Syntax Highlighting
;; Add all the file extensions to use the mode with
(use-package web-mode
  :mode (("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.html?\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.fxml\\'" . web-mode))
  :config ;; Set styling
          (setq web-mode-markup-indent-offset 2)
          (setq web-mode-css-indent-offset 2))

;; Allow Recent Files to be seen across sessions
(use-package recentf
  :bind ("C-x C-r" . recentf-open-files)
  :config (recentf-mode 1)
          (setq recentf-max-menu-items 100)
          (setq recentf-max-saved-items 200)
          ;; Save recent files every 5 minutes
          (run-at-time nil (* 5 60) `recentf-save-list))

;; Let's add a line to show if the line is too long
(use-package fill-column-indicator
  :init (add-hook 'prog-mode-hook 'fci-mode)
        (add-hook 'css-mode-hook 'fci-mode)
  :config (setq fci-rule-column 80))

;; Workgroups mode saves desktop window positions
;; REMEMBER, there is a piece at the end of .emacs
(use-package workgroups2
  :config (setq wg-prefix-key (kbd "C-c z"))
          (setq wg-session-file "~/.emacs.d/.emacs_workgroups"))

;; Symbol Highlighting
(use-package highlight-symbol
  :bind ("M-l" . highlight-symbol-at-point)
        ("C-l" . highlight-symbol-next)
        ("C-S-l" .  highlight-symbol-prev)
        ("C-x C-l" . replace-symbol-in-buffer) ;; Replace Symbol
  :config (setq highlight-symbol-foreground-color "White")
          (setq highlight-symbol-on-navigation-p t)
          (setq highlight-symbol-colors
                '("DarkCyan" "DeepPink" "MediumPurple1"
                  "DarkOrange" "HotPink1" "RoyalBlue1" "OliveDrab")))

;; Expand Region
(use-package expand-region
  :config (global-set-key (kbd "C-=") 'er/expand-region))

;; Be smart about matching parens
(use-package smartparens-config
  :config (add-hook 'prog-mode-hook #'smartparens-mode)
          (add-hook 'css-mode-hook #'smartparens-mode))

;; Show diffs like git diff does
(use-package diff-hl
  :config (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
          (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))
;; When Using Magit 2.4 or newer use this:
;;(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; Multiple Cursors
(use-package multiple-cursors
  :bind ("C->" . mc/mark-next-like-this)
        ("C-<" . mc/mark-previous-like-this)
        ("C-S-<mouse-1>" . mc/add-cursor-on-click))

;; Highlight Numbers
(use-package highlight-numbers
  :config (add-hook 'prog-mode-hook 'highlight-numbers-mode)
          (add-hook 'web-mode-hook 'highlight-numbers-mode)
          (add-hook 'css-mode-hook 'highlight-numbers-mode))

;; Highlight Parentheses
(use-package highlight-parentheses
  :config (add-hook 'prog-mode-hook 'highlight-parentheses-mode))

;; Exec Path From Shell
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

;;===========Midnight mode for cleaning up buffers============;
;;; midnight mode
(require 'midnight)

;;kill buffers if they were last disabled more than this seconds ago
(setq clean-buffer-list-delay-special 3600)

(defvar clean-buffer-list-timer nil
  "Stores clean-buffer-list timer if there is one. You can disable clean-buffer-list by (cancel-timer clean-buffer-list-timer).")

;; run clean-buffer-list every 2 hours
(setq clean-buffer-list-timer (run-at-time t 7200 'clean-buffer-list))

;; kill everything, clean-buffer-list is very intelligent at not killing
;; unsaved buffer.
(setq clean-buffer-list-kill-regexps '("^.*$"))

;; keep these buffer untouched
;; prevent append multiple times
(defvar clean-buffer-list-kill-never-buffer-names-init
  clean-buffer-list-kill-never-buffer-names
  "Init value for clean-buffer-list-kill-never-buffer-names")
(setq clean-buffer-list-kill-never-buffer-names
      (append
       '("*Messages*" "*cmd*" "*scratch*" "*w3m*" "*w3m-cache*" "*Inferior Octave*")
       clean-buffer-list-kill-never-buffer-names-init))

;; prevent append multiple times
(defvar clean-buffer-list-kill-never-regexps-init
  clean-buffer-list-kill-never-regexps
  "Init value for clean-buffer-list-kill-never-regexps")
;; append to *-init instead of itself
(setq clean-buffer-list-kill-never-regexps
      (append '("^\\*EMMS Playlist\\*.*$")
	      clean-buffer-list-kill-never-regexps-init))

;;====================== Helm Mode ===========================;

;; It's time to take the helm
(use-package helm
  :bind ("M-x" . helm-M-x)
        ("C-x C-f" . helm-find-files)
        ("C-c C-f" . helm-for-files)
        ("C-x b" . helm-mini)
  :init (require 'helm-config)
  :config (defvar helm-ff-skip-boring-files)
          (defvar helm-ff-file-name-history-use-recentf)
          (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
                helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
                helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
                helm-ff-file-name-history-use-recentf t)
          (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
          (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
          (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
          (helm-autoresize-mode 1)
          ;;Limit the number of packages shown for speed
          ;;(setq helm-candidate-number-limit 5000)//Can be removed when you next notice this past September 2016
          (setq helm-ff-skip-boring-files t))

;; Helm Projectile
(use-package helm-projectile
  :bind ("s-f" . helm-projectile-find-file)
  :config (projectile-global-mode)
          (setq projectile-completion-system 'helm)
          (helm-projectile-on))

;; Helm Describe bindings
(use-package helm-descbinds
  :config (helm-descbinds-mode))

;; Fuzzy Matching
(use-package helm-flx
  :config (helm-flx-mode +1))

(use-package helm-git-grep
  :bind ("C-c g" . helm-git-grep)
  :config  ;; Invoke `helm-git-grep' from isearch.
           (define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
           ;; Invoke `helm-git-grep' from other helm.
           (eval-after-load 'helm
             '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)))

;; This is the old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; End Helm
(helm-mode 1)

;;==================Cheat Sheet Additions=====================;
;; Cheat Sheet
(use-package cheetsheet
  :bind ("C-x C-h" . cheatsheet-show)
  :init (cheatsheet-add :group 'Common :key "C-x C-c" :description "Quit Emacs.")
        (cheatsheet-add :group 'Common :key "C-x k" :description "Kill Buffer")
        (cheatsheet-add :group 'Common :key "C-g" :description "Quit Minibuffer")
        (cheatsheet-add :group 'Common :key "C-c g" :description "Helm Git Grep")
        (cheatsheet-add :group 'Common :key "M-x load-file" :description "For use when working with the .emacs file")

        (cheatsheet-add :group 'Editing :key "M-; or S-/" :description "Mass Commenting")
        (cheatsheet-add :group 'Editing :key "C-x C-l" :description "Find and Replace all")
        (cheatsheet-add :group 'Editing :key "C-c C-k" :description "Copy Current Line")
        (cheatsheet-add :group 'Editing :key "C-g" :description "Cancel Minibuffer")
        (cheatsheet-add :group 'Editing :key "M-x font-lock-fontify-buffer" :description "Reload Highlighting")
        (cheatsheet-add :group 'Editing :key "M-x replace-string" :description "Replaces a string with another string")
        (cheatsheet-add :group 'Editing :key "C-x C-q" :description "Toggle Read-Only Mode")
        (cheatsheet-add :group 'Editing :key "C-c c" :description "Clear all Reported errors")
        (cheatsheet-add :group 'Editing :key "C-> or C-<" :description "Multiple Cursors")

        (cheatsheet-add :group 'Terminal :key "$ pwd" :description "Shows path to current directory in terminal")
        (cheatsheet-add :group 'Terminal :key "$ tree" :description "Shows a tree of the current directory")
        (cheatsheet-add :group 'Terminal :key "$ lsof -wni tcp:PORT" :description "Shows what's running at the input port number")
        (cheatsheet-add :group 'Terminal :key "$ kill -9 PID" :description "Kills whatever was on that PID")

        (cheatsheet-add :group 'Rails_Console :key "User.connection.select_values(User.select('email').to_sql)"
                        :description "Generates a list of all the users in the db")

        (cheatsheet-add :group 'Workgroups :key "C-c z" :description "Prefix to initialize workgroups")
        (cheatsheet-add :group 'Workgroups :key "c" :description "Create A Workgroup")
        (cheatsheet-add :group 'Workgroups :key "C-f" :description "Load Session")
        (cheatsheet-add :group 'Workgroups :key "C-s" :description "Save Session")
        (cheatsheet-add :group 'Workgroups :key "k" :description "Kill Workgroup")
        (cheatsheet-add :group 'Workgroups :key "v" :description "Switch to Workgroup")

        (cheatsheet-add :group 'Helm :key "C-h b" :description "Activate Descbinds (you should do this in a helm minibuffer)")

        (cheatsheet-add :group 'Other :key "C-c C-h" :description "Shows all key-bindings for 'C-c'")
        (cheatsheet-add :group 'Other :key "C-h f" :description "Shows the bindings for the input command")
        (cheatsheet-add :group 'Other :key "M-x rainbow-mode" :description "Displays Colors on RGB and HEX values")
        (cheatsheet-add :group 'Other :key "M-x xkcd" :description "Displays today's comic. Use 'r' to get random comic")
        (cheatsheet-add :group 'Other :key "M-x server-start" :description "Starts emacs listening for commands from IntelliJ"))

;; Things that must be placed at the bottom
(workgroups-mode 1)
(require 'helm-command)
