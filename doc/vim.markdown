# Vim commands

## Bindings

Note: the **map leader** is `,`.

- `<C-h>` Move to right split
- `<C-j>` Move to above split
- `<C-k>` Move to below split
- `<C-l>` Move to left split

- `:W` save current buffer using sudo

- `F2` toggle paste mode
- `F3` toggle GitGutter

- `<leader>2` use 2 spaces indent
- `<leader>4` use 4 spaces indent

- `<leader>a` start ack search
- `<leader>za` ack current word under cursor

- `<leader>s` search/replace
- `<leader>zs` search/replace current word under cursor
- `<leader>/` clear current search highlight

- `<leader>l` show/hide hidden chars
- `<leader>m` call make
- `<leader>d` show/hide ale details

- `<C-Space>` call onmifunc completion
- `<leader>e` open/close a left panel with file explorer in current file
  directory
- `` <leader>` `` open/close a left panel with file explorer in cwd

- `<F8>` Move to previous error (coc)
- `<S-F8>` Move to next error (coc)
- `<K>` Show documentation in previous window (coc)
- `<leader>d` Got to definition (coc)
- `<leader>t` Got to type definition (coc)
- `gr` list references (coc)
- `gr` list implementations (coc)
- `<leader>?` Describe the symbol under cursor: ALEHover (ALE)

- `<C-p>` Fuzzy search for file (fzf)
- `<leader>ff` Fuzzy search for file (fzf)
- `<leader>fb` Fuzzy search for buffer (fzf)
- `<leader>fc` Fuzzy search for commit in repo history (fzf)
- `<leader>c` Fuzzy search for commit in current buffer history (fzf)

## Commands

To add a new spell language, just run `set spelllang=fr`. This will
automatically install dictionary.

~Close **syntastic** error panel using `:lclose`~ I don't use syntastics
anymore.

## Folding

By default folding is off. To turn it on use `zi`

## Javascript Specific

- `F4` :FlowToggle (toggle flow check on file save)
- `<C-l>` Lint current file with eslint

## Nice to know vim tips

### Variable scope

See `:help internal-variables`

It lists the following types:

- (nothing) In a function: local to a function; otherwise: global
- buffer-variable b: Local to the current buffer.
- window-variable w: Local to the current window.
- tabpage-variable t: Local to the current tab page.
- global-variable g: Global.
- local-variable l: Local to a function.
- script-variable s: Local to a :source'ed Vim script.
- function-argument a: Function argument (only inside a function).
- vim-variable v: Global, predefined by Vim.
