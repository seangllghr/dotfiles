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
                 :family "Fira Code"
                 :size 16
                 )
      doom-variable-pitch-font (font-spec
                                :family "Latin Modern Roman"
                                :size 18
                                ))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

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

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(setq-default js2-basic-offset 2)

(global-display-fill-column-indicator-mode)
(add-hook! 'markdown-mode-hook 'turn-on-auto-fill)
(add-hook! 'text-mode-hook 'turn-on-auto-fill)
(add-hook! 'org-mode-hook 'no-fill-column)
(defun no-fill-column ()
  (display-fill-column-indicator-mode 0))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
;; (setq! flycheck-global-modes '(not org-mode))

(after! org
  (setq org-latex-pdf-process '("latexmk --xelatex %f"))
  (require 'ox-bibtex)
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
          ("x11names"     "xcolor"    t)
          ("colorlinks=true,allcolors=darkgray" "hyperref" nil)
          ("margin=1in"   "geometry"  t)
          (""             "fontspec"  t)
          (""             "setspace"  t)
          ("tiny,compact" "titlesec"  t))
        )
  (setq org-latex-classes
        '(("article"
           "\\documentclass[11pt]{article}
[DEFAULT-PACKAGES]
\\doublespacing
\\setlength{\\leftmargini}{0em}
\\titleformat*{\\section}{\\centering\\bfseries}
\\titleformat*{\\subsubsection}{\\itshape}
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
