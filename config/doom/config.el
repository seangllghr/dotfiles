;; Shell overrides
;; We'll start with a few shell overrides to keep Emacs happy.
;; I use Fish as my login shell---though I also use Xonsh and Nu a great deal when their relevant strengths are in-demand---but Emacs expects a POSIX shell for certain things.
;; Doom's ~doctor~ command will complain loudly about the matter, but this shuts it up.


;; [[file:config.org::*Shell overrides][Shell overrides:1]]
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))
;; Shell overrides:1 ends here

;; ~whoami~

;; [[file:config.org::*~whoami~][~whoami~:1]]
(setq user-full-name "Sean Gallagher"
      user-mail-address "sean@gallaghersw.dev")
;; ~whoami~:1 ends here

;; Theme
;; I've grown fond of [[https://github.com/morhetz/gruvbox][gruvbox]], with its warm grays and retro-inspired colors.
;; I don't have any science to back the assertion that it's easier on the eyes than cool palettes, but I /did/ order a deskmat in the colorscheme, so now I'm committed.


;; [[file:config.org::*Theme][Theme:1]]
(setq! doom-theme 'doom-gruvbox
       doom-gruvbox-dark-variant "hard")
;; Theme:1 ends here

;; Fonts
;; I'm fond of [[https://github.com/tonsky/FiraCode][Fira Code]]---I find programming ligatures dramatically improve the legibility of code.
;; I use the NerdFont version for its expanded symbol support.
;; For variable-pitch, I've abandoned the delicate pseudo-serifs of [[https://github.com/alerque/libertinus][Libertinus Sans]] for the utilitarian legibility and consistency of [[https://mozilla.github.io/Fira/][Fira Sans]].
;; I've also got [[https://juliamono.netlify.app/][Julia Mono]] as a fallback for symbolics.


;; [[file:config.org::*Fonts][Fonts:1]]
(setq! doom-font (font-spec :family "FiraCode Nerd Font" :size 15 :weight 'medium)
       doom-variable-pitch-font (font-spec :family "Fira Sans")
       doom-symbol-font (font-spec :family "JuliaMono" :size 14))
(custom-set-faces!
  '(highlight-indent-guides :foreground "#665c54")
  '(fill-column-indicator :foreground "#665c54"))
;; Fonts:1 ends here



;; Once I confirm =mixed-pitch= is installed and working, I use these settings to make mixed-pitch modes (like =org-mode= look more uniform).


;; [[file:config.org::*Fonts][Fonts:2]]
(use-package! mixed-pitch
  :config
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 124))
;; Fonts:2 ends here



;; I also have some additional ligature-related settings.
;; Just a couple.


;; [[file:config.org::*Fonts][Fonts:3]]
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
  (global-ligature-mode t))
;; Fonts:3 ends here

;; Miscellaneous visual settings
;; Finally, we have a few additional bits of visual miscellanea.


;; [[file:config.org::*Miscellaneous visual settings][Miscellaneous visual settings:1]]
(setq display-line-numbers-type 'relative)
(setq! doom-modeline-buffer-file-name-style 'truncate-with-project
       fill-column 88)  ;; Make sure the DeLorean is up to 88 mph
(global-display-fill-column-indicator-mode)
(setq! indent-tabs-mode nil
       adaptive-wrap-extra-indent 6)
;; Miscellaneous visual settings:1 ends here

;; Python

;; [[file:config.org::*Python][Python:1]]
(defun python-mode-tweaks () (rainbow-delimiters-mode 1) (rainbow-mode 1))
(add-hook! 'python-mode-hook 'python-mode-tweaks)
;; Python:1 ends here

;; JSON

;; [[file:config.org::*JSON][JSON:1]]
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
  (rainbow-delimiters-mode 1)
  (apheleia-mode -1))
(add-hook! 'json-mode-hook 'json-mode-tweaks)
;; JSON:1 ends here

;; Markdown
;; Since I discovered =org-mode=, I use Markdown /almost/ exclusively for READMEs in shared projects that others might work on[fn:1].
;; I won't force them to adopt to my particular SemBr quirks---which I myself have started to drift away from---so we'll configure =markdown-mode= to give us a pleasant reading and editing experience.


;; [[file:config.org::*Markdown][Markdown:1]]
(defun markdown-mode-tweaks ()
    (display-fill-column-indicator-mode 0)
    (mixed-pitch-mode 1)
    (+word-wrap-mode 0)
    (turn-off-auto-fill)
    (turn-on-visual-line-mode)
    (setq! visual-fill-column-enable-sensible-window-split t
           visual-fill-column-width 88
           adaptive-wrap-extra-indent 4)
    (visual-fill-column-mode 1)
    (adaptive-wrap-prefix-mode 1))
(add-hook! 'markdown-mode-hook 'markdown-mode-tweaks)
;; Markdown:1 ends here

;; Org
;; This one's destined to be a doozy.
;; First things first, let's get this pointed at my Org files.


;; [[file:config.org::*Org][Org:1]]
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; Org:1 ends here



;; Everything else will go in an src_emacs-lisp{(after! org)}, so we'll open that here, too.

;; [[file:config.org::*Org][Org:2]]
(after! org
;; Org:2 ends here

;; Custom functions
;; At some point, I wrote this function to automatically omit headlines unless I explicitly want them.
;; The idea was headlines should be available as an organizational tool without necessarily affecting the structure of the output document.
;; I don't use it much anymore, but it's nice to have, and I don't want to lose the work.

;; [[file:config.org::*Custom functions][Custom functions:1]]
(defun org-export-noignore-headlines (data _ info)
  "Remove headlines not tagged \"noignore\".
    The \"noignore\" tag marks headlines that will be retained.
    For all other headlines,contents are retained and any children headlines
    are promoted to the level of the parent."
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
                        (org-element-put-property
                         el
                         :level (- (org-element-property :level el)
                                   level-diff)))))
                  ;; insert back into parse tree
                  (org-element-insert-before el object))
                (org-element-contents object)))
        (org-element-extract-element object)))
    info nil)
  data)

(defun org-export-activate-ignore-headlines ()
  "Activates ignore-headlines and deactivates noignore-headlines"
  (ox-extras-deactivate '(noignore-headlines))
  (ox-extras-activate '(ignore-headlines)))

(defun org-export-activate-noignore-headlines ()
  "Deactivates ignore-headlines and activates noignore-headlines"
  (ox-extras-deactivate '(ignore-headlines))
  (ox-extras-activate '(noignore-headlines)))
;; Custom functions:1 ends here

;; Appearance Tweaks
;; I use a collection of minor modes and tweaks to make editing Org documents a little easier on the eyes.

;; [[file:config.org::*Appearance Tweaks][Appearance Tweaks:1]]
(defun org-mode-minor-tweaks ()
    (org-indent-mode 0)
    (display-fill-column-indicator-mode 0)
    (mixed-pitch-mode 1)
    (+word-wrap-mode 0)
    (turn-off-auto-fill)
    (turn-on-visual-line-mode)
    (setq! visual-fill-column-enable-sensible-window-split t
           visual-fill-column-width 88
           adaptive-wrap-extra-indent 4)
    (visual-fill-column-mode 1)
    (adaptive-wrap-prefix-mode 1))
(add-hook! 'org-mode-hook 'org-mode-minor-tweaks)
;; Appearance Tweaks:1 ends here



;; These customizations make my headlines, bullets, and priorities prettier.

;; [[file:config.org::*Appearance Tweaks][Appearance Tweaks:2]]
(use-package! org-superstar ; "prettier" bullets
    :hook (org-mode . org-superstar-mode)
    :config
    ;; Make leading stars truly invisible, by rendering them as spaces!
    (setq org-superstar-leading-bullet ?\s
          org-superstar-leading-fallback ?\s
          org-hide-leading-stars nil
          org-superstar-todo-bullet-alist
          '(("TODO" . 9744)
            ("[ ]"  . 9744)
            ("DONE" . 9745)
            ("[X]"  . 9745))
          org-superstar-item-bullet-alist
          '((?* . ?•)
            (?+ . ?+)
            (?- . ?—))
          org-superstar-headline-bullets-list
          '("◈" "▣" "◉" "◆" "◾" "•")))

(use-package! org-fancy-priorities
    :hook (org-mode . org-fancy-priorities-mode)
    :hook (org-agenda-mode . org-fancy-priorities-mode)
    :config (setq org-fancy-priorities-list ' ("⚑" "⬆" "■")))

(setq org-ellipsis " ⌄"
        org-hide-emphasis-markers 1
        org-pretty-entities 1)
;; Appearance Tweaks:2 ends here



;; I also have some custom datetime formatting for exports.

;; [[file:config.org::*Appearance Tweaks][Appearance Tweaks:3]]
(setq-default org-display-custom-times nil)
(setq org-time-stamp-custom-formats
      '("​%A, %d %B, %Y​" . "​%A, %d %B, %Y, %H:%M %Z​")
      org-duration-format 'h:mm)
;; Appearance Tweaks:3 ends here

;; Files
;; My two Org files in standard rotation are =work.org= and =personal.org=.
;; Org's default capture destination---=notes.org=---is a name that I tend to use for project files, so calling the primary agenda file =notes.org= increases the number of same-name buffers that I'm likely to have open in any given session.
;; I'd like to capture into =work.org= by default, so we'll set that here.

;; [[file:config.org::*Files][Files:1]]
(setq! org-default-notes-file (concat org-directory "work.org"))
;; Files:1 ends here

;; Workflow states
;; I have a whole collection of custom TODO states, which enable very fine-grained progress tracking.
;; I don't really use them all that often, but I like knowing the option exists.
;; Also, if I ever get around to Plane/Jira sync, this'll keep things less lossy.

;; [[file:config.org::*Workflow states][Workflow states:1]]
(setq org-todo-keywords
        '((sequence "TODO(t!)" "STRT(s!)" "TEST(u!)" "REVIEW(r!)" "|" "DONE(d!)")
          ;; Exceptional/alternate states
          (sequence "BLOCK(b@!)" "KNOWNCAUSE(c@!)" "ACCEPTANCE(R!)" "PUSH(p!)"
                    "|" "PUNT(P@!)" "CANCEL(k@!)")
          ;; Lightweight/subtask states
          (sequence "[ ](T)" "[-](S)" "[◆](U)" "[?](H)" "[!](B)" "|" "[✓](D)" "[X](K)")
          ;; Long-term/container states
          (sequence "LOOP(l)" "PROJ(j)" "IDEA(i)" "FEAT(f)" "|")))
;; Workflow states:1 ends here



;; With all of those custom states come a whole boatload of custom colors...

;; [[file:config.org::*Workflow states][Workflow states:2]]
(setq org-todo-keyword-faces
      '(("PROJ" . (:foreground "#fbf1c7" :weight bold))
        ("IDEA" . "#ebdbb2") ("[?]" ."#ebdbb2")
        ("FEAT" . "#458588")
        ("BUG" . "#fe8019")
        ("TODO" . "#d3869b") ("[ ]" . "#d3869b") ("LOOP" . "#b16286")
        ("STRT" . "#fabd2f") ("[-]" . "#fabd2f")
        ("PUSH" . "#fe8019")
        ("BLOCK" . "#cc241d") ("[!]" . "#cc241d")
        ("KNOWNCAUSE" . "#83a598") ("TEST" . "#83a598") ("[◆]" . "#83a598")
        ("REVIEW" . "#b8bb26") ("ACCEPTANCE" . "#b8bb26")
        ("PUNT" . "#928374") ("CANCEL" . "#928374") ("[X]" . "#928374")))
;; Workflow states:2 ends here

;; Priorities
;; I think I'm also going to switch to custom priorities.
;; It'll probably break my pretty priority symbols, but that's something I'm going to have to live with.

;; [[file:config.org::*Priorities][Priorities:1]]
(setq! org-priority-highest ?A
       org-priority-lowest ?E
       org-priority-default ?C
       org-priority-faces
       '((?A . "#fb4934")
         (?B . "#fe8019")
         (?C . "#fabd2f")
         (?D . "#83a598")
         (?E . "#bdae93"))
       org-fancy-priorities-list
       '((?A . "‼")
         (?B . "⯅")
         (?C . "━")
         (?D . "⯆")
         (?E . "⯀")))
;; Priorities:1 ends here

;; Capture Templates
;; Some custom capture templates...

;; [[file:config.org::*Capture Templates][Capture Templates:1]]
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/work.org" "INBOX")
         "* TODO [#B] %?\nSCHEDULED: %t\n:LOGBOOK:\n- State \"TODO\"       from \"\"           %U\n:END:"
         :empty-lines 0)
        ("T" "Personal todo" entry (file+headline "~/org/personal.org" "INBOX")
         "* TODO [#B] %?\nSCHEDULED: %t\n:LOGBOOK:\n- State \"TODO\"       from \"\"           %U\n:END:"
         :empty-lines 0)
        ("c" "Calendar event" entry (file+headline "~/org/work.org" "INBOX")
         "* %?\n%t")
        ("C" "Personal calendar event" entry (file+headline "~/org/work.org" "INBOX")
         "* %?\n%t")))
;; Capture Templates:1 ends here

;; Misc settings
;; ... and any miscellaneous task-tracking settings.

;; [[file:config.org::*Misc settings][Misc settings:1]]
(setq org-log-into-drawer t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-deadline-prewarning-if-scheduled t
      org-agenda-skip-scheduled-if-deadline-is-shown t
      org-agenda-skip-scheduled-delay-if-deadline t
      org-agenda-skip-scheduled-if-done t)
;; Misc settings:1 ends here

;; TODO LaTeX export settings
;; At some point, I had a whole bunch of LaTeX export classes and related settings.
;; I /believe/ some component therein may have been the source of my config headaches.
;; So we're going to take this slow.

;; [[file:config.org::*LaTeX export settings][LaTeX export settings:1]]

;; LaTeX export settings:1 ends here

;; Close ~after! org~
;; This section is just here to close the src_emacs-lisp{(after! org)}.
;; I'm aware that it'll generate ugly Lisp.

;; [[file:config.org::*Close ~after! org~][Close ~after! org~:1]]
)
;; Close ~after! org~:1 ends here

;; Copilot, which Copilot suggests I use "because I'm a lazy bum".

;; [[file:config.org::*Copilot, which Copilot suggests I use "because I'm a lazy bum".][Copilot, which Copilot suggests I use "because I'm a lazy bum".:1]]
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
;; Copilot, which Copilot suggests I use "because I'm a lazy bum".:1 ends here

;; Mode toggles

;; [[file:config.org::*Mode toggles][Mode toggles:1]]
(map! (:leader (:prefix "t"
                :desc "Apheleia mode" "a" #'apheleia-mode))
      (:leader (:prefix "t"
                :desc "Global Apheleia mode" "A" #'apheleia-global-mode))
      (:leader (:prefix "t"
                :desc "Visual Fill Column mode" "C" #'visual-fill-column-mode))
      (:leader (:prefix "t"
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
;; Mode toggles:1 ends here

;; Debug commands

;; [[file:config.org::*Debug commands][Debug commands:1]]
(map! (:leader
       (:prefix-map ("d" . "debugger")
        :desc "Launch GDB" "d" #'gdb
        :desc "Disassembly buffer" "a" #'gdb-display-disassembly-buffer
        :desc "GDB buffer" "g" #'gdb-display-gdb-buffer
        :desc "Registers buffer" "r" #'gdb-display-registers-buffer
        :desc "Source buffer" "s" #'gdb-display-source-buffer
        :desc "UI many windows" "m" #'gdb-many-windows)))
;; Debug commands:1 ends here

;; Windowing

;; [[file:config.org::*Windowing][Windowing:1]]
(map! (:leader
       (:prefix "w" (:prefix "g"
                     :desc "Resize to Golden Ratio" "g" #'golden-ratio))))
;; Windowing:1 ends here

;; Extra one-offs

;; [[file:config.org::*Extra one-offs][Extra one-offs:1]]
(map! (:leader (:prefix "c" :desc "Format buffer (apheleia)" "F" #'apheleia-format-buffer)))
;; Extra one-offs:1 ends here
