" activate javscript autocompletion
setlocal omnifunc=javascriptcomplete#CompleteJS

" override default behavior
" insert comment on new line
set formatoptions+=c
set formatoptions+=r
set formatoptions+=o


" Gandi got me into 2 spaces indent instead of 4
setlocal tabstop=2 shiftwidth=2 softtabstop=2
setlocal tabstop=2 shiftwidth=2 softtabstop=2

augroup ftplugin_javascript_indent
    " reset group autocommand
    autocmd!

    " set options for gandi projects
    autocmd BufEnter */Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd BufEnter */Projects/caliopen/* setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " set options for datadog projects
    autocmd BufEnter */Projects/datadog/* setlocal tabstop=4 shiftwidth=4 softtabstop=4
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

"Use locally installed flow
let s:local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(s:local_flow, "^\/\\w") == ''
  let s:local_flow= getcwd() . "/" . s:local_flow
endif
if executable(s:local_flow)
  let g:flow#flowpath = s:local_flow
endif

" If flow binary was found, setup flow
let s:activate_flow = filereadable(g:flow#flowpath)
" if this is a gandi project, we want flow too.
if matchstr(expand('%:p:h'), "Projects\/gandi\/") == 'Projects/gandi/'
  let s:activate_flow = 1
endif

if s:activate_flow
  let g:flow#autoclose = 1
  let g:flow#enable = 1
  let g:flow#omnifunc = 1
  " Toggle flow checks
  nnoremap <buffer> <F4> :FlowToggle<CR>
else
  let g:flow#enable = 0
endif

" lint all curly braces to add spaces
" Not sure this is correctly bound though
" :%s:\$\@<!{\s*\([^}]\{-1,}\)\s*}:{ \1 }:<CR>
" :%s:\[\s*\([^\]]\{-}\)\s*]:[\1]:gc

