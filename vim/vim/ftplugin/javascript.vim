" activate javscript autocompletion
setlocal omnifunc=javascriptcomplete#CompleteJS

" override default behavior
" insert comment on new line
setlocal formatoptions+=c
setlocal formatoptions+=r
setlocal formatoptions+=o

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


" Use zi to switch folding
setlocal nofoldenable

" configure pangloss/vim-javascript
setlocal foldmethod=syntax
let b:javascript_fold = 1
let b:javascript_plugin_jsdoc = 1
let b:javascript_plugin_flow = 1

" configure https://github.com/mxw/vim-jsx
let b:jsx_ext_required = 0

" use eslint to check syntax
let g:syntastic_javascript_checkers = ['eslint']
nmap <buffer> <C-l> :!eslint %<CR>
" If available, use local eslint (thanks to
" https://github.com/mtscout6/syntastic-local-eslint.vim)
let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let g:syntastic_javascript_eslint_exec = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')


"******************************************************************************
" Flow
" see https://github.com/flowtype/vim-flow
"******************************************************************************

" disable by default
let g:flow#enable = 0

" general configuration
let g:flow#autoclose = 1
let g:flow#omnifunc = 1

if themouette#HasNodeModuleExec('flow')
    " Use the best flow binary
    let g:flow#flowpath = themouette#FindNodeModulesExec('flow')

    " Bind flow toggle to F4
    nnoremap <buffer> <F4> :FlowToggle<CR>

    augroup ftplugin_javascript_flow
        autocmd!

        " enable different behaviors depending on the project
        if themouette#IsGandiProject()
            " - gandi flow is defined as a single global instance
            autocmd BufEnter <buffer> let g:flow#enable = 1

        elseif themouette#HasLocalNodeModuleExec('flow')
            " - default: if there is a local flow bin
            autocmd BufEnter <buffer> let g:flow#enable = 1
        endif
    augroup END
endif
