" set options for gandi projects
autocmd BufEnter ~/Projects/gandi/* setlocal colorcolumn=80
autocmd BufEnter ~/Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Scss linter
let g:syntastic_scss_checkers = ['scss_lint']
" Relies on https://github.com/causes/scss-lint
nmap <buffer> <C-l> :!/usr/local/bin/scss-lint %<CR>
