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

* `<C-Space>` call onmifunc completion

## Commands

To add a new spell language, just run `set spelllang=fr`. This will
automatically install dictionary.

Close **syntastic** error panel using `:lclose`

## Folding

By default folding is off. To turn it on use `zi`

## Javascript Specific

* `F5` :FlowToggle (toggle flow check on file save)
* `<C-l>` Lint current file with eslint

