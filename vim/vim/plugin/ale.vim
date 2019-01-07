" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

let g:ale_open_list = 0
let g:ale_list_vertical = 0
let g:ale_echo_msg_format = '[%linter%] %s %(code) %[%severity%]'

" Navigate through errors easily
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <leader>d <Plug>(ale_next_wrap)

" Better :sign interface symbols
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

" Use tslint to lint tsx files
" https://github.com/w0rp/ale/issues/1662
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters = { 'typescript': ['tsserver', 'tslint'] }

" Register my Ale configuration depending on file type
" Argument: N/A
" Return: {void}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RegisterMyAleSetup()
    " echom 'ALE detect Filetype: '.&ft

    " Here we can setup things depending on filetype or anything else
    " We can access filetype through `&ft`.
    " To check if filetype is in a list:
    "
    " if count(['c','cpp','python'],&filetype)
    augroup ale_buffer_autocmd
        autocmd!
    augroup END

    " Execute logic here to add autocommands:
    "
    " autocmd ale_buffer_autocmd BufWritePre  <buffer>
    "            | :echom 'BufWritePre '.expand('<amatch>')."--".bufnr('%')
    if count(['python'],&filetype)
        " Autofix python code
        let b:ale_fix_on_save = 1
        let b:ale_fixers = { 'python': ['black'] }
        " Force local configuration file to be able to open file outside of
        " `dogweb` dir.
        if themouette#IsDataDogProject()
            let b:python_black_options = '--config ~/Projects/datadog/dogweb/pyproject.toml'
        endif
        " :echom 'I just added format on save'
    endif
endfunction

" Clear auto command group
augroup ale_register_setup
    autocmd!
augroup END

" On every BufEnter, we configure the plugin
" BufEnter allows to have an augroup for each buffer
autocmd ale_register_setup BufEnter  * call RegisterMyAleSetup()
