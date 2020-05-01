" As :Lex remaps <C-l>
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    nnoremap <silent> <buffer> <c-l> :TmuxNavigateRight<CR>
endfunction
