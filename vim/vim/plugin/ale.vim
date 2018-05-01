" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

let g:ale_open_list = 1
let g:ale_list_vertical = 0

" Navigate through errors easily
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Better :sign interface symbols
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

augroup ale_auto_close_loclist
    autocmd!
augroup END
