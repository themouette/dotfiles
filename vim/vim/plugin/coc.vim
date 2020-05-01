" This file is my configuration file for neoclide/coc.vim plugin.
" coc is an inteli

" Ensure update time is short to have a better feedback loop
set updatetime=300

" Setup prettier
" See https://github.com/neoclide/coc-prettier#usage
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
" Format code
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Navigate through errors
nmap <silent> <F8> <Plug>(coc-diagnostic-prev)
nmap <silent> <S-F8> <Plug>(coc-diagnostic-next)

" To code navigation.
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
