" set omnifunc completion
setlocal omnifunc=pythoncomplete#Complete

setlocal tabstop=4 shiftwidth=4 softtabstop=4
setlocal tabstop=4 shiftwidth=4 softtabstop=4

" configure generics on a per project basis
augroup ftplugin_python_indent
    autocmd!

    " set options for gandi projects
    autocmd BufEnter ~/Projects/gandi/* setlocal colorcolumn=80
    autocmd BufEnter ~/Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END


" Configure 'sbdchd/neoformat'
" Configure auto formatting on save on a per project basis
augroup ftplugin_python_fmt
    autocmd!
    autocmd BufWritePre <buffer> undojoin | Neoformat
augroup END
