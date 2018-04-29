" override default behavior
" insert comment on new line
setlocal formatoptions+=c
setlocal formatoptions+=r
setlocal formatoptions+=o

" Indent
setlocal tabstop=4 shiftwidth=4 softtabstop=4
setlocal tabstop=4 shiftwidth=4 softtabstop=4

" configure generics on a per project basis
augroup ftplugin_sh_indent
    autocmd!
augroup END

" Configure 'sbdchd/neoformat'
" Configure auto formatting on save on a per project basis
augroup ftplugin_sh_fmt
    autocmd!
    autocmd BufWritePre <buffer> undojoin | Neoformat
augroup END
