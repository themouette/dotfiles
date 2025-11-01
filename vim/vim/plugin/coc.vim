" This file is my configuration file for neoclide/coc.vim plugin.
" coc is an inteli

" Ensure update time is short to have a better feedback loop
set updatetime=300

" Install plugins
let g:coc_global_extensions = [
    \  'coc-tsserver',
    \  'coc-json',
    \  'coc-html',
    \  'coc-css',
    \  'coc-prettier',
    \  'coc-eslint',
    \  'coc-python',
    \  'coc-phpls',
    \  'coc-yaml',
    \  'coc-git'
    \]

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Setup prettier
" See https://github.com/neoclide/coc-prettier#usage
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
" Format code
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Navigate through errors
nmap <silent> <S-F8> <Plug>(coc-diagnostic-prev)
nmap <silent> <F8> <Plug>(coc-diagnostic-next)

" To code navigation.
"nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>d :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>f :call CocFix<CR>
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Rename symbol under cursor
nmap <leader>r <Plug>(coc-rename)
" Those commands were removed from latest Coc
command! -nargs=* -range CocAction :call CocActionAsync('codeActionRange', <line1>, <line2>, <f-args>)
command! -nargs=* -range CocFix    :call CocActionAsync('codeActionRange', <line1>, <line2>, 'quickfix')

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
