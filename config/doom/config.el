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
                                :family "Latin Modern Roman"
                                :size 18)
      doom-unicode-font (font-spec
                         :family "Noto Mono"
                         :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'doom-gruvbox)

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
(add-hook! 'org-mode-hook 'no-fill-column)
(defun no-fill-column ()
  (display-fill-column-indicator-mode 0))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;;******************** ORG CUSTOMIZATIONS ********************;;

(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;; (setq! flycheck-global-modes '(not org-mode))

(after! org
  (setq org-latex-pdf-process '("latexmk --xelatex %f"))
  (require 'ox-bibtex)
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
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
          ("my-article"
           "\\documentclass[11pt]{article}
[DEFAULT-PACKAGES]
\\usepackage[margin=1in]{geometry}
\\usepackage[x11names]{xcolor}
\\usepackage[colorlinks=true,allcolors=darkgray]{hyperref}
\\usepackage{fontspec}
\\usepackage{setspace}
\\usepackage[tiny,compact]{titlesec}
\\setlength{\\leftmargini}{0em}
\\titleformat*{\\section}{\\centering\\bfseries}
\\titleformat*{\\subsubsection}{\\itshape\\bfseries}
\\titlespacing{\\paragraph}{\\parindent}{0em}{1em}
\\titleformat*{\\subparagraph}{\\itshape\\bfseries}
\\usepackage[style=apa,backend=biber]{biblatex}
\\DeclareLanguageMapping{american}{american-apa}
\\doublespacing
[PACKAGES]"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ("report"
           "\\documentclass[11pt]{report}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
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
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
        )
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
        (?- . ?-)))

;; Email stuff =======================================================

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
      mu4e-index-cleanup t
      mu4e-index-lazy-check nil
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "seangllghr@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
(setq! mu4e-update-interval 300)
(setq! org-msg-default-alternatives '(text html))
