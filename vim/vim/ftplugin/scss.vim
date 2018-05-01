" code indent
if themouette#IsGandiOrCaliopenProject()
    setlocal colorcolumn=80
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
else
    setlocal colorcolumn=80
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
endif

" Scss linter
" let b:syntastic_scss_checkers = ['scss_lint']

" Relies on https://github.com/causes/scss-lint
nmap <buffer> <C-l> :!/usr/local/bin/scss-lint %<CR>
