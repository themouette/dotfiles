setlocal colorcolumn=80
setlocal tabstop=4 shiftwidth=4 softtabstop=4
setlocal tabstop=4 shiftwidth=4 softtabstop=4

" Auto remove tailing spaces
augroup ftplugin_vim_whitespace
    autocmd!
    autocmd BufWritePre <buffer> :call StripTrailingWhitespace()
augroup END

