" override default behavior
" insert comment on new line
autocmd BufEnter * setlocal formatoptions+=c
autocmd BufEnter * setlocal formatoptions+=r
autocmd BufEnter * setlocal formatoptions+=o

" set options for gandi projects
" autocmd BufEnter ~/Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2
" autocmd BufEnter ~/Projects/caliopen/* setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Gandi got me into 2 spaces indent instead of 4
autocmd BufEnter * setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufEnter * setlocal tabstop=2 shiftwidth=2 softtabstop=2

" use eslint to check syntax
let g:syntastic_javascript_checkers = ['eslint']
nmap <buffer> <C-l> :!eslint %<CR>
" If available, use local eslint (thanks to
" https://github.com/mtscout6/syntastic-local-eslint.vim)
let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let b:syntastic_javascript_eslint_exec = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')

" configure https://github.com/mxw/vim-jsx
let g:jsx_ext_required = 0

