# Nushell Environment Config File
#
# version = 0.80.0

$env.STARSHIP_SHELL = "nu"
$env.STARSHIP_SESSION_KEY = (random chars -l 16)

def create_left_prompt [] {
    ( starship prompt
        --cmd-duration=$env.CMD_DURATION_MS
        $'--status=($env.LAST_EXIT_CODE)'
        $'--terminal-width=((term size).columns)'
    )
}

def create_right_prompt [] {
    let time_segment_color = (ansi magenta)

    let time_segment = ([
        (ansi reset)
        $time_segment_color
        (date now | date format '%Y-%m-%d | %H:%M')
    ] | str join | str replace --all "([/:])" $"(ansi light_magenta_bold)${1}($time_segment_color)")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = "" # {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = "" # {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = "" # {|| ":> " }
$env.PROMPT_INDICATOR_VI_NORMAL = "" # {|| " > " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::> " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# Add some common patterns for parsing
$env.ISO8601_REGEX = '(?x)(?<Timestamp>
    \d{4}(?:-\d{2}){2} # Date
    [T\ ] # Separator
    \d{2}(?::\d{2}){1,2}(?:[.,]\d{1,9})? # Time
    (?:Z|[-+]\d{2}(?::?\d{2})?)? # Timezone
)'

# Add us some aliases
alias la = ls -a
alias ll = ls -la

# and some alias-y functions
def ls-zip [zipfile] {
    unzip -l $zipfile | lines | skip 3 | drop 2 |
    parse -r ('^\s*(?<Length>\d+)\s+' + $env.ISO8601_REGEX + '\s+(?<Name>.*)$') |
    each {|rec| (
        update Length ($rec.Length | into int) |
        update Timestamp ($rec.Timestamp | into datetime)
    )}
}

zoxide init nushell |
    str replace --all "def-env" "def --env" |
    str replace --all "-- $rest" "-- ...$rest" |
    save -f ~/.config/nushell/zoxide.nu