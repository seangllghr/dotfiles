;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sean Gallagher"
      user-mail-address "seangllghr@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec
                 :family "JetBrains Mono"
                 :size 16
                 )
      doom-variable-pitch-font (font-spec
                                :family "Libertinus Sans"
                                :size 19)
      doom-unicode-font (font-spec
                         :family "Noto Sans Mono"
                         :size 16))

(setq! +ligatures-extra-symbols
       ;; Not sure why, but several of the default symbols don't seem to exist
       '(:name          "»"
         :src_block     "»"
         :src_block_end "«"
         :quote         "“"
         :quote_end     "”"
         ;; Functional
         :lambda        "λ"
         :def           "ƒ"
         :composition   "∘"
         :map           "↦"
         ;; Types
         :null          "∅"
         :true          "⊤"
         :false         "⊥"
         :int           "ℤ"
         :float         "ℝ"
         :str           "𝕊"
         :bool          "⊤⊥"
         :list          "[]"
         ;; Flow
         :not           "¬"
         :in            "∈"
         :not-in        "∉"
         :and           "∧"
         :or            "∨"
         :for           "∀"
         :some          "∃"
         :return        "⟼"
         :yield         "⟻"
         ;; Other
         :union         "⋃"
         :intersect     "∩"
         :diff          "∖"
         :tuple         "⨂"
         :pipe          ""
         :dot           "•"))

(use-package! mixed-pitch
  :config
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 1.3))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'doom-gruvbox)
(setq doom-gruvbox-dark-variant "hard")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq-default enable-local-variables t)

;; golden-ratio
(use-package! golden-ratio
  :after-call pre-command-hook
  :config
  (golden-ratio-mode +1)
  (remove-hook 'window-configuration-change-hook #'golden-ratio)
  (add-hook 'doom-switch-window-hook #'golden-ratio))

;; Edit with Emacs edit server
(use-package! edit-server
  :ensure t
  :commands edit-server-start
  :init (if after-init-time
            (edit-server-start)
          (add-hook 'after-init-hook
                    #'(lambda() (edit-server-start))))
  :config (setq edit-server-new-frame-alist
                '((name . "Edit with Emacs FRAME")
                  (top . 200)
                  (left . 200)
                  (width . 80)
                  (height . 25)
                  (minibuffer . t)
                  (menu-bar-lines . t)
                  (window-system . x))))

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(setq-default js-indent-level 2)

(global-display-fill-column-indicator-mode)
(add-hook! 'markdown-mode-hook 'turn-on-auto-fill)
(add-hook! 'text-mode-hook 'turn-on-auto-fill)

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(setq treemacs-indentation 1)
(setq treemacs-indentation-string "│")

;;********************* ORG CUSTOMIZATIONS *********************;;

(add-hook! 'org-mode-hook 'org-mode-tweaks)
(defun org-mode-tweaks ()
  (display-fill-column-indicator-mode 0)
  (mixed-pitch-mode 1)
  (+word-wrap-mode 0)
  (turn-off-auto-fill))

(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
;; (setq! flycheck-global-modes '(not org-mode))

;; custom ox-extras function to include only headlines tagged 'noignore'
(defun org-export-noignore-headlines (data backend info)
  "Remove headlines not tagged \"noignore\" retaining contents and promoting children.
Each headline tagged \"noignore\" will not be removed retaining its
contents and promoting any children headlines to the level of the
parent."
  (org-element-map data 'headline
    (lambda (object)
      (when (not (member "noignore" (org-element-property :tags object)))
        (let ((level-top (org-element-property :level object))
              level-diff)
          (mapc (lambda (el)
                  ;; recursively promote all nested headlines
                  (org-element-map el 'headline
                    (lambda (el)
                      (when (equal 'headline (org-element-type el))
                        (unless level-diff
                          (setq level-diff (- (org-element-property :level el)
                                              level-top)))
                        (org-element-put-property el
                          :level (- (org-element-property :level el)
                                    level-diff)))))
                  ;; insert back into parse tree
                  (org-element-insert-before el object))
                (org-element-contents object)))
        (org-element-extract-element object)))
    info nil)
  data)

(after! org
  (setq org-latex-pdf-process '("latexmk --xelatex --shell-escape %f"))
  (require 'ox-bibtex)
  (require 'ox-extra)
  (add-to-list 'ox-extras '(noignore-headlines
                            org-export-noignore-headlines
                            org-export-filter-parse-tree-functions))
  (ox-extras-activate '(noignore-headlines))
  (setq org-latex-default-packages-alist
        '((""             "graphicx"  t)
          (""             "grffile"   t)
          (""             "longtable" nil)
          (""             "wrapfig"   nil)
          (""             "rotating"  nil)
          ("normalem"     "ulem"      t)
          (""             "amsmath"   t)
          (""             "textcomp"  t)
          (""             "amssymb"   t)
          (""             "capt-of"   nil)
          (""             "titling"   t))
        )
  (setq org-latex-classes
        '(("article"
           "\\documentclass[11pt]{article}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ("particle"
           "\\documentclass[11pt]{article}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}"))
          ("report"
           "\\documentclass[11pt]{report}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
          ("one-part-report"
           "\\documentclass[11pt]{report}"
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}"))
          ("book"
           "\\documentclass[11pt]{book}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
          ("apa7"
           "\\documentclass[
11pt,man,
noextraspace,floatsintext,
babel,american,
biblatex
]{apa7}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
\\hypersetup{colorlinks=true,allcolors=black}
\\DeclareLanguageMapping{american}{american-apa}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ("beamer"
           "\\documentclass{beamer}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{graphicx}
\\usepackage{grffile}
\\usepackage{longtable}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{amssymb}
\\usepackage{capt-of}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
  (setq org-latex-title-command "\\maketitle")
  )

(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats
      '("​%A, %d %B %Y​" . "​%A, %d %B %Y, %H:%M %Z​"))

(setq org-superstar-headline-bullets-list
       '("◈"
         "▣"
         "◉"
         "◆"
         "◾"
         "•"))

(setq org-superstar-item-bullet-alist
      '((?* . ?•)
        (?+ . ?+)
        (?- . ?—)))

(setq org-hide-emphasis-markers t)

(setq org-latex-listings 'minted)

(setq org-ellipsis " ⌄")

(defmacro def-and-bind-quoted-text-obj (name key start-regex end-regex)
  (let ((inner-name (make-symbol (concat "evil-inner-" name)))
        (outer-name (make-symbol (concat "evil-a-" name))))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key #',inner-name)
       (define-key evil-outer-text-objects-map ,key #',outer-name))))

(def-and-bind-quoted-text-obj "tilde" "~" "~" "~")
(def-and-bind-quoted-text-obj "equals" "=" "=" "=")
(def-and-bind-quoted-text-obj "slash" "/" "/" "/")
(def-and-bind-quoted-text-obj "plus" "+" "+" "+")
(def-and-bind-quoted-text-obj "underscore" "_" "_" "_")

;; Email stuff ======================================================

;; Add mu4e to loadpath on Ubuntu
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

;; General email settings
(set-email-account!
 "seangllghr@gmail.com"
 '((mu4e-sent-folder    . "/seangllghr@gmail.com/[Gmail]/Sent Mail")
   (mu4e-drafts-folder  . "/seangllghr@gmail.com/[Gmail]/Drafts")
   (mu4e-trash-folder   . "/seangllghr@gmail.com/[Gmail]/Trash")
   (mu4e-refile-folder  . "/seangllghr@gmail.com/[Gmail]/All Mail")
   (smtpmail-smtp-user  . "seangllghr@gmail.com"))
 t)

(setq message-send-mail-function 'smtpmail-send-it
      mu4e-get-mail-command "true"
      mu4e-index-cleanup t
      mu4e-index-lazy-check nil
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "seangllghr@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

;; (mu4e-alert-set-default-style 'libnotify)
;; (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;; (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
;; (setq! mu4e-update-interval 300)
(setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil"
      org-msg-startup "hidestars indent inlineimages"
      org-msg-default-alternatives '((new               . (text html))
                                     (reply-to-html     . (text html))
                                     (reply-to-text     . (text)))
      org-msg-convert-citation t)

;; Extra keybinds
(map! (:leader (:prefix "t" :desc "Golden ratio" "G" #'golden-ratio-mode))
      (:leader (:prefix "t" :desc "Follow mode" "L" #'follow-mode))
      (:leader (:prefix "t" :desc "Variable pitch" "v" #'variable-pitch-mode)))

(map! (:leader
       (:prefix-map ("d" . "debugger")
        :desc "Launch GDB" "d" #'gdb
        :desc "Disassembly buffer" "a" #'gdb-display-disassembly-buffer
        :desc "GDB buffer" "g" #'gdb-display-gdb-buffer
        :desc "Registers buffer" "r" #'gdb-display-registers-buffer
        :desc "Source buffer" "s" #'gdb-display-source-buffer
        :desc "UI many windows" "m" #'gdb-many-windows)))
