" First, define some global functions

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find local executable for a node_module.
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returns: {string} the fullpath to the command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:find_local_node_modules_exec(module_cmd)
    let cmd_path = finddir('node_modules', '.;') . '/.bin/' . a:module_cmd

    " make sure this is an absolute path
    if matchstr(cmd_path, "^\/\\w") == ''
        let cmd_path = getcwd() . "/" . cmd_path
    endif
    " check it is executable
    if executable(cmd_path)
        return cmd_path
    endif

    return ""
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a module command exists or not in current project's
" node_modules
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returns: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:has_local_node_module_exec(module_cmd)
    return strlen(s:find_local_node_modules_exec(a:module_cmd)) > 0
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find the best matching executable from a node_module.
" Always prefer local version of the package, and fallback on a global version
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returns: {string} the fullpath to the command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:find_node_modules_exec(module_cmd)
    let cmd_path = s:find_local_node_modules_exec(a:module_cmd)
    " check it is executable
    if strlen(cmd_path)
        return cmd_path
    endif

    " attempt to find a globaly installed npm package matching the request
    if !executable('npm')
        return ""
    endif

    let cmd_path = system('npm bin -g')[:-2] . "/" . a:module_cmd
    " check it is executable
    if executable(cmd_path)
        return cmd_path
    endif

    return ""
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check wether a module command exists or not
"
" Arguments
" * module_cmd: the executable script to look for (i.e. 'prettier', 'flow'...)
"
" Returns: {boolean}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:has_node_module_exec(module_cmd)
    return strlen(s:find_node_modules_exec(a:module_cmd)) > 0
endfunction



" activate javscript autocompletion
setlocal omnifunc=javascriptcomplete#CompleteJS

" override default behavior
" insert comment on new line
setlocal formatoptions+=c
setlocal formatoptions+=r
setlocal formatoptions+=o

" code indent
setlocal tabstop=4 shiftwidth=4 softtabstop=4
setlocal tabstop=4 shiftwidth=4 softtabstop=4

augroup ftplugin_javascript_indent
    " reset group autocommand
    autocmd!

    " set options for gandi projects
    autocmd BufEnter */Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd BufEnter */Projects/caliopen/* setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " set options for datadog projects
    autocmd BufEnter */go/src/github.com/DataDog/* setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

" Use zi to switch folding
setlocal nofoldenable

" configure pangloss/vim-javascript
setlocal foldmethod=syntax
let b:javascript_fold = 1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" use eslint to check syntax
let g:syntastic_javascript_checkers = ['eslint']
nmap <buffer> <C-l> :!eslint %<CR>
" If available, use local eslint (thanks to
" https://github.com/mtscout6/syntastic-local-eslint.vim)
let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let g:syntastic_javascript_eslint_exec = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')

" configure https://github.com/mxw/vim-jsx
let g:jsx_ext_required = 0

" Use flow
" see https://github.com/flowtype/vim-flow

if s:has_node_module_exec('flow')
  " Use the best flow binary
  let g:flow#flowpath = find_node_modules_exec('flow')
  " Bind flow togle to F4
  nnoremap <buffer> <F4> :FlowToggle<CR>
endif

" general configuration
let b:flow#autoclose = 1
let b:flow#omnifunc = 1
" disable by default
let b:flow#enable = 0

" enable or not
augroup ftplugin_javascript_flow
    autocmd!
    " enable different behaviors depending on the project
    " - gandi
    autocmd BufEnter */Projects/gandi/* let b:flow#enable = 1

    " - default: if there is a local flow bin
    if s:has_local_node_module_exec('flow')
      autocmd BufEnter <buffer> let b:flow#enable = 1
    endif
augroup END


" Configure 'sbdchd/neoformat'
let b:neoformat_verbose = 0

" Override the default prettier bin if there is one installed
if s:has_node_module_exec('prettier')
    let b:neoformat_javascript_prettier = {
                \ 'exe': s:find_node_modules_exec('prettier'),
                \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
                \ 'stdin':1
                \ }
endif

augroup ftplugin_javascript_fmt
    autocmd!
    " run formatter on save depending on the project
    " - datadog
    autocmd BufEnter */go/src/github.com/DataDog/* undojoin | Neoformat

    " - default: if there is a local prettier bin
    if s:has_local_node_module_exec('prettier')
      autocmd BufWritePre <buffer> undojoin | Neoformat
    endif
augroup END

