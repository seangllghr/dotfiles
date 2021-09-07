config.load_autoconfig()

# Some mildly dynamic font configuration, for fun and profit
class FontConfig:
    def __init__(self):
        self.families = {
            'serif': 'TeX Gyre Pagella',
            'sans': 'TeX Gyre Heros',
            'mono': 'JetBrains Mono'
        }
        self.sizes = {
            'small': '10pt',
            'base': '12pt',
            'large': '14pt'
        }

    def font(self, size, family):
        return self.sizes[size] + ' ' + self.families[family]

fc = FontConfig()

# UI Configuration
c.new_instance_open_target = 'window'
c.downloads.position = 'bottom'
## Tabs
c.tabs.background = True
c.tabs.show = 'multiple'
## Editor
c.editor.command = ["emacsclient", "-a", "emacs", "-c", "+{line}:{column}", "{file}"]

# Fonts
c.fonts.completion.category = fc.font('small', 'sans')
c.fonts.default_family = fc.families['mono']
c.fonts.default_size = fc.sizes['base']
c.fonts.hints = fc.font('large', 'mono')
c.fonts.web.family.serif = fc.families['serif']
c.fonts.web.family.sans_serif = fc.families['sans']
c.fonts.web.family.fixed = fc.families['mono']
c.fonts.web.size.default = round(((int) (fc.sizes['base'][0:2]) * 4) / 3)
c.fonts.web.size.default_fixed = round(((int) (fc.sizes['base'][0:2]) * 4) / 3)

# Dark Mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.threshold.background = 64
c.colors.webpage.darkmode.policy.images = 'smart'
c.colors.webpage.preferred_color_scheme = 'dark'

# Theme and Colors
## Load the theme file
config.source('gruvbox.py')
## Tweaks
c.colors.webpage.bg = "#1d2021"

# Load my keybinds
config.source('bindings.py')
