" set omnifunc completion
setlocal omnifunc=pythoncomplete#Complete

" code indent
if themouette#IsDataDogProject()
    setlocal colorcolumn=80
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
elseif themouette#IsGandiOrCaliopenProject()
    setlocal colorcolumn=100
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
    setlocal tabstop=2 shiftwidth=2 softtabstop=2
else
    setlocal colorcolumn=80
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
    setlocal tabstop=4 shiftwidth=4 softtabstop=4
endif


" Configure 'sbdchd/neoformat'
" Configure auto formatting on save on a per project basis
augroup ftplugin_python_fmt
    autocmd!
    autocmd BufWritePre <buffer> undojoin | Neoformat
augroup END
