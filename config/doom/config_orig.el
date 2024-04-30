;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Shell overrides
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sean Gallagher"
      user-mail-address "sean@gallaghersw.dev")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq! doom-theme 'doom-gruvbox
       doom-gruvbox-dark-variant "hard")

;; Font stuff
(setq! doom-font (font-spec :family "FiraCode Nerd Font" :size 13 :weight 'medium)
       doom-variable-pitch-font (font-spec :family "Libertinus Sans")
       doom-symbol-font (font-spec :family "JuliaMono" :size 14))
(custom-set-faces!
  '(highlight-indent-guides :foreground "#3c3836")
  '(fill-column-indicator :foreground "#3c3836"))

                                        ; (use-package! mixed-pitch
                                        ; :config
                                        ; (setq mixed-pitch-set-height t)
                                        ; (set-face-attribute 'variable-pitch nil :height 1.3))

(after! ligature
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" (+ "*"))))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  (setq! +ligatures-extra-symbols
         ;; Not sure why, but several of the default symbols don't seem to exist
         '(:name "≔"  :src_block "«"  :src_block_end "»"  :quote "“"  :quote_end "”"
           ;; Functional
           :lambda "λ"  :def "ƒ"  :composition "∘"  :map "↦"
           ;; Types
           :null "∅"  :true "⊤"  :false "⊥"  :int "ℤ"
           :float "ℝ"  :str "𝕊"  :bool "⊤⊥"  :list "[]"
           ;; Flow
           :not "¬"  :in "∈"  :not-in  "∉"  :and "∧"  :or "∨"
           :for "∀"  :some "∃"  :return "⟼"  :yield "⟻"
           ;; Other
           :union "⋃"  :intersect "∩"  :diff "∖"  :tuple "⨂"
           :pipe ""  :dot "•"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)

;; Some other general display-related options
(setq! doom-modeline-buffer-file-name-style 'truncate-with-project
       fill-column 88)  ;; Make sure the DeLorean is up to 88 mph
(global-display-fill-column-indicator-mode)
(setq! indent-tabs-mode nil
       adaptive-wrap-extra-indent 6)

;; *** Mode-specific customizations

(defun python-mode-tweaks () (rainbow-delimiters-mode 1) (rainbow-mode 1))
(add-hook! 'python-mode-hook 'python-mode-tweaks)

(defun json-mode-tweaks ()
  (display-fill-column-indicator-mode 0)
  (mixed-pitch-mode 0)
  (+word-wrap-mode 1)
  (turn-off-auto-fill)
  (turn-on-visual-line-mode)
  (visual-fill-column-mode 1)
  (setq! visual-fill-column-enable-sensible-window-split t
         visual-fill-column-width 100
         js-indent-level 2)
  (rainbow-delimiters-mode 1))
(add-hook! 'json-mode-hook 'json-mode-tweaks)

;; *** Org customizations

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; TODO: Integrate all of the other crap.

;; Extra keybinds
;; Additional toggles
(map! (:leader (:prefix "t"
                :desc "Follow mode" "L" #'follow-mode))
      (:leader (:prefix "t"
                :desc "Golden ratio" "G" #'golden-ratio-mode))
      (:leader (:prefix "t"
                :desc "Variable pitch" "v" #'variable-pitch-mode))
      (:leader (:prefix "t"
                :desc "Rainbow mode" "R" #'rainbow-mode))
      (:leader (:prefix "t"
                :desc "Org LSP" "o" #'lsp-org))
      (:leader (:prefix "t"
                :desc "Mixed pitch mode" "M" #'mixed-pitch-mode)))

;; Copilot, which Copilot suggests I use "because I'm a lazy bum".
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
