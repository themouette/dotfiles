Vim commands
============

## Bindings

Note: the **map leader** is `,`.

* `:W` save current buffer using sudo

* `F2` toggle paste mode
* `F3` toggle GitGutter

* `<leader>2` use 2 spaces indent
* `<leader>4` use 4 spaces indent

* `<leader>a` start ack search
* `<leader>za` ack current word under cursor

* `<leader>s` search/replace
* `<leader>zs` search/replace current word under cursor
* `<leader>/` clear current search highlight

* `<leader>l` show/hide hidden chars
* `<leader>m` call make
* `<leader>d` show/hide ale details

* `<C-Space>` call onmifunc completion
* `<leader>e` open/close a left panel with file explorer

* `<leader>f` format current file with Neoformat

* `<C-k>` Move to previous error (ALE)
* `<C-j>` Move to next error (ALE)

## Commands

To add a new spell language, just run `set spelllang=fr`. This will
automatically install dictionary.

Close **syntastic** error panel using `:lclose`

## Folding

By default folding is off. To turn it on use `zi`

## Javascript Specific

* `F4` :FlowToggle (toggle flow check on file save)
* `<C-l>` Lint current file with eslint

## Nice to know vim tips

### Variable scope

See `:help internal-variables`

It lists the following types:

 * (nothing) In a function: local to a function; otherwise: global
 * buffer-variable    b:     Local to the current buffer.
 * window-variable    w:     Local to the current window.
 * tabpage-variable   t:     Local to the current tab page.
 * global-variable    g:     Global.
 * local-variable     l:     Local to a function.
 * script-variable    s:     Local to a :source'ed Vim script.
 * function-argument  a:     Function argument (only inside a function).
 * vim-variable       v:     Global, predefined by Vim.
