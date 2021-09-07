config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')

config.bind('xx', 'close')
config.bind('xt', 'tab-close')
config.bind('O', 'set-cmd-text -s :open -w')
config.bind('F', 'hint all window')

config.bind(',v', 'hint links spawn --verbose --detach mpv {hint-url} --input-ipc-server=/tmp/mpvsocket')

# Spacemacs-style bindings for common actions
config.bind('<Space>fed', 'config-edit')
config.bind('<Space>ff', 'set-cmd-text -s :open')
config.bind('<Space>fn', 'set-cmd-text -s :open -w')
config.bind('<Space>fF', 'set-cmd-text -s :open -t')

config.bind('<Space>qq', 'quit')
config.bind('<Space>qf', 'close')

config.bind('<Space>wd', 'tab-close')
