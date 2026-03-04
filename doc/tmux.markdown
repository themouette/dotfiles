# Tmux

It is possible to move focus from vim pane to tmux pane using `ctrl + hjkl`.

## Layouts

### `tmux-layout`

Applies the standard work layout to the current window:

- Left pane: full height, ~70% width
- Right panes: 30% width, split in two equal halves

```sh
tmux-layout              # uses current directory for right panes
tmux-layout ~/Projects   # sets right panes to a specific directory
```

## Shortcuts

Here is a list of Tmux Shortcut taken from https://zserge.com/posts/tmux/
- Mod+1..9: switch windows from 1 to 9
- Mod+, and Mod+.: switch to next/prev windows
- Mod+HJKL or arrows: switch between panes
- Mod+N: create new window
- Mod+f: toggle full-screen
- Mod+v: split vertically
- Mod+b: split horizontally (“bisect”)
- Mod+x: close pane
- Mod+/: enter copy and scroll mode
- Mod+< and Mod+>: move current window to the left/right
- Mod+Shift+HJKL or arrows: move pane to the left/right/up/down
- Mod+Shift+X: close window
- Mod+Shift+R: rename window
