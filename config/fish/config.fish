if status is-interactive
    # enable vi key bindings
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    # set a greeting message (I don't even know when I got this format anymore)
    function fish_greeting
        if type -q lsb_release
            echo $USER@$hostname $(uname -srm) $(lsb_release -irs)
        else
            echo $USER@$hostname $(uname -srm)
        end
    end

    # Aliases for fun and profit

    ## ergonomic defaults
    abbr -a cp 'cp -iv'
    abbr -a df 'df -h'
    abbr -a du 'du -h'
    abbr -a free 'free -m'
    abbr -a mkd 'mkdir -pv'
    abbr -a mv 'mv -iv'
    abbr -a rm 'rm -vI'

    ## pretty colors
    abbr -a diff 'diff --color=auto'
    abbr -a grep 'grep --color=auto'
    abbr -a ip 'ip --color=auto'
    abbr -a pacman 'pacman --color=auto'
    abbr -a tree 'tree -C'

    ## ls (if exa is installed)
    if type -q exa
        abbr -a ls 'eza --icons --color=always'
        abbr -a la 'eza --icons --color=always'
        abbr -a ll 'eza --long --icons --color=always --git'
    end

    ## systemctl
    abbr -a sctl 'systemctl --user'
    abbr -a ssctl 'sudo systemctl'

    ## A boatload of git aliases that I'll never remember
    abbr -a g 'git'
    abbr -a gc 'git commit'
    abbr -a gca 'git commit --amend'
    abbr -a gcm 'git commit -m'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gf 'git fetch'
    abbr -a gg 'git status'  # gs is awkard on my keyboard layout
    abbr -a ggo 'git checkout'
    abbr -a gl 'git log'
    abbr -a gla 'git log --all'
    abbr -a glp 'git log --patch'
    abbr -a gp 'git pull'
    abbr -a gpu 'git push'
    abbr -a gsh 'git show'
    abbr -a gst 'git stash'
    abbr -a gsta 'git stash apply'
    abbr -a gstl 'git stash list'
    abbr -a gstp 'git stash pop'
    abbr -a gstu 'git stash --include-untracked'
    abbr -a gstua 'git stash apply --include-untracked'
    abbr -a gstul 'git stash list --include-untracked'
    abbr -a gstup 'git stash pop --include-untracked'

    ## Bat aliases (if bat is installed)
    if type -q bat
        abbr -a bap 'bat --paging=always'
        abbr -a bal 'bat --language'
        abbr -a bapl 'bat --paging=always --language'
        abbr -a baj 'bat --language json' # I deal with a *lot* of json
        abbr -a bapj 'bat --paging=always --language json'
    end

    ## Miscelaneous
    abbr -a ds 'date "+%Y%m%d"'
    abbr -a dts 'date "+%Y%m%d_%H%M%S"'
    abbr -a lamk 'latexmk -xelatex -shell-escape'
    abbr -a lns 'ln -sv'
    abbr -a xco 'xclip -selection clipboard -o'
    abbr -a xcp 'xclip -selection clipboard'
    abbr -a xo 'xdg-open'

    # Alias-like functions
    function cd
        builtin cd $argv
        if test $status -eq 0
            if type -q exa
                exa --icons --color=always
            else
                ls -F --color=always
            end
        end
    end

    function lr
        # Recursively list all files in the current directory and its children
        if type -q exa && type -q moar
            exa --icons --color=always -lagT --git --git-ignore -I '.git' $argv |
                moar --follow --no-linenumbers --no-statusbar --quit-if-one-screen
            echo ''
        else
            echo 'Missing dependencies:'
            type -q exa || echo '  exa'
            type -q moar || echo '  moar'
        end
    end

    # Name some directories that I use often
    ## Common directories
    set -Ux cf $HOME/.config
    set -Ux D $HOME/Downloads
    set -Ux d $HOME/Documents
    set -Ux dl $HOME/.local
    set -Ux dls $dl/share
    set -Ux lb $dl/bin
    set -Ux src $dl/src
    set -Ux ut $tmp

    ## Personal projects
    set -Ux dots $HOME/dotfiles
    set -Ux gs $HOME/git-software
    set -Ux s $HOME/scripts
    set -Ux mins $d/Camp/TRC_Aquatics/Committee/meeting_notes

    ## Work work
    ### General
    set -Ux spa $d/Work/1Spatial
    set -Ux repo $spa/repo
    set -Ux proj $spa/Projects
    set -Ux int $spa/1Integrate

    ### Repositories
    set -Ux sc $repo/sync_configs
    set -Ux dash $repo/con_saas_dashboard
    set -Ux egc $repo/con_geom_essentials
    set -Ux enc $repo/con_network_essentials
    set -Ux ems $repo/con_saas_ng911

    ### Projects
    set -Ux mn $proj/MN911
    set -Ux adoa $proj/ADOA
    set -Ux clab $proj/CATTLab
    set -Ux nena $proj/NENA
    set -Ux mt $proj/MT

    # init the starship prompt
    if type -q starship
        starship init fish | source
    end
    # init zoxide
    if type -q zoxide
        zoxide init fish | source
    end
end
