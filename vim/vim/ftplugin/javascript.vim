" activate javscript autocompletion
:setlocal omnifunc=javascriptcomplete#CompleteJS

" override default behavior
" insert comment on new line
:setlocal formatoptions+=c
:setlocal formatoptions+=r
:setlocal formatoptions+=o

" set options for gandi projects
" autocmd BufEnter ~/Projects/gandi/* setlocal tabstop=2 shiftwidth=2 softtabstop=2
" autocmd BufEnter ~/Projects/caliopen/* setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Gandi got me into 2 spaces indent instead of 4
:setlocal tabstop=2 shiftwidth=2 softtabstop=2
:setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Use zi to switch folding
:setlocal nofoldenable

" configure pangloss/vim-javascript
:setlocal foldmethod=syntax
let b:javascript_fold = 1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" use eslint to check syntax
let g:syntastic_javascript_checkers = ['eslint']
nmap <buffer> <C-l> :!eslint %<CR>
" If available, use local eslint (thanks to
" https://github.com/mtscout6/syntastic-local-eslint.vim)
let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let b:syntastic_javascript_eslint_exec = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')

" configure https://github.com/mxw/vim-jsx
let g:jsx_ext_required = 0

" Use flow
" see https://github.com/flowtype/vim-flow

"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = local_flow
endif

" If flow binary was found, setup flow
if filereadable(g:flow#flowpath)
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

