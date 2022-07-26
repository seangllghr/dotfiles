# A collection of classes for theme data
import pprint

color_names = ['black', 'red', 'green', 'yellow',
               'blue', 'magenta', 'cyan', 'white']

default_colors = [
    '#000000', '#808080',
    '#800000', '#ff0000',
    '#008000', '#00ff00',
    '#808000', '#ffff00',
    '#000080', '#0000ff',
    '#800080', '#ff00ff',
    '#008080', '#00ffff',
    '#c3c3c3', '#ffffff'
]

gruv_dark_colors = [
    '#1d2021', '#3c3836',
    '#cc241d', '#fb4934',
    '#98971a', '#b8bb26',
    '#d79921', '#fabd2f',
    '#458588', '#83a598',
    '#b16286', '#d3869b',
    '#689d6a', '#8ec07c',
    '#d5c4a1', '#fbf1c7',
    ['#1d2021', '#3c3836', '#504945', '#665c54', '#7c6f64'],
    ['#fbf1c7', '#ebdbb2', '#d5c4a1', '#bdae93', '#a89984']
]


class PaletteColor:
    '''Data class to hold normal and bright variants of a single color'''

    def __init__(self, norm, bright):
        self.norm = norm
        self.bright = bright

class Palette:
    '''Class implementing some palette stuff'''
    def __init__(self, name, colors=default_colors, bg=None, fg=None):
        self.__dict__ = palette_dict_from_color_list(colors)
        self.bg = [ self.black.norm ] if bg is None else bg
        self.fg = [ self.white.bright ] if fg is None else fg
        self.name = name

    def __str__(self):
        string = f'{self.name}:\n'
        for key in self.__dict__:
            if isinstance(self.__dict__[key], PaletteColor):
                string += '{:11s} {}; {}\n'.format(
                    key.capitalize() + ':',
                    self.__dict__[key].norm,
                    self.__dict__[key].bright,
                )
            else:
                if isinstance(self.__dict__[key], list):
                    for idx,val in enumerate(self.__dict__[key]):
                        string += f'{key}{idx}: {val}\n'
        return string

def palette_dict_from_color_list(colors):
    '''Takes a list of 16 or 18 colors and generates a palette dict'''
    color_dict = {}
    for idx,color in enumerate(color_names):
        if len(colors) > 0:
            norm = colors.pop(0)
        else:
            norm = default_palette[idx * 2]

        if len(colors) > 0:
            bright = colors.pop(0)
        else:
            bright = default_palette[(idx * 2) + 1]

        color_dict[color] = PaletteColor(norm, bright)

    return color_dict

if __name__ == '__main__':
    gruvbox = Palette('Default', gruv_dark_colors, gruv_dark_colors[16], gruv_dark_colors[17])
    print(str(gruvbox))
