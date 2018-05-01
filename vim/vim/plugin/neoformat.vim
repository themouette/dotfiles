"******************************************************************************
" Configure Neoformat
" see https://github.com/sbdchd/neoformat
"******************************************************************************

let b:neoformat_verbose = 0
nnoremap <buffer> <leader>f :Neoformat<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup Neoformat for everything that depends on prettier
"
" Argument: N/A
"
" Return: {void}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SetupNeoformatFrontend()
    " By default Neoformat does not use local bins for prettier
    if themouette#HasNodeModuleExec('prettier')
        let b:neoformat_javascript_prettier = {
                    \ 'exe': themouette#FindNodeModulesExec('prettier'),
                    \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
                    \ 'stdin':1
                    \ }
    endif

    " DataDog only uses prettier BUT has some other formatters installed
    if themouette#IsDataDogProject()
        let b:neoformat_enabled_javascript = ['prettier']
    endif

    augroup ftplugin_fmt
        autocmd!
        " run formatter on save depending on the project
        if themouette#HasLocalNodeModuleExec('prettier')
            " - default: if there is a local prettier bin
            autocmd BufWritePre <buffer> undojoin | Neoformat
        endif
    augroup END
endfunction

augroup themouette_plugins_neoformat
    autocmd!

    autocmd FileType javascript call SetupNeoformatFrontend()
    autocmd FileType css call SetupNeoformatFrontend()
    autocmd FileType scss call SetupNeoformatFrontend()
    autocmd FileType less call SetupNeoformatFrontend()
    autocmd FileType json call SetupNeoformatFrontend()
    autocmd FileType html call SetupNeoformatFrontend()
    autocmd FileType yaml call SetupNeoformatFrontend()
augroup END
