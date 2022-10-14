" WARNING: This file is not used anymore since I moved away from ale in
" favor of coc.
" Ale does both auto format AND syntax checker.
finish
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Enable autocomplete
let g:ale_completion_enabled = 1

let g:ale_open_list = 0
let g:ale_list_vertical = 0
let g:ale_echo_msg_format = '[%linter%] %s %(code) %[%severity%]'

" Navigate through errors easily
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" show usefull info
nmap <silent> <leader>d <Plug>(ale_detail)
nmap <silent> <leader>? <Plug>(ale_hover)

" Better :sign interface symbols
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

" Use tslint to lint tsx files
" https://github.com/w0rp/ale/issues/1662
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters = { 'typescript': ['tsserver', 'tslint', 'eslint'] }

" Register my Ale configuration depending on file type
" Argument: N/A
" Return: {void}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RegisterMyAleSetup()
    " echom 'ALE detect Filetype: '.&ft
    " disable autocomplete by default
    let b:ale_completion_enabled = 0

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
    if &filetype =~# 'javascript' ||
                \ &filetype =~# 'typescript' ||
                \ &filetype =~# 'css' ||
                \ &filetype =~# 'scss' ||
                \ &filetype =~# 'less' ||
                \ &filetype =~# 'json' ||
                \ &filetype =~# 'html' ||
                \ &filetype =~# 'yaml' ||
                \ &filetype =~# 'markdown'

        " Setup prettier config as soon as the module is available
        if themouette#HasNodeModuleExec('prettier')
            " set prettier executable
            let b:javascript_prettier_executable = themouette#FindNodeModulesExec('prettier')
        endif
        if themouette#HasNodeModuleExec('tsserver')
            " set prettier executable
            let b:ale_typescript_tsserver_executable = themouette#FindNodeModulesExec('tsserver')
        endif
        if themouette#HasNodeModuleExec('eslint')
            " set prettier executable
            let b:javascript_eslint_executable = themouette#FindNodeModulesExec('eslint')
        endif

        " Custom setup for datadog project
        if themouette#IsDataDogProject()
            " Explicitely use prettier only as datadog has some unused
            " linter configs at root level and it triggers automatically
            let b:ale_fixers = ['prettier']
            " Force local configuration file to be able to open file outside of
            " `statics` dir.
            let b:javascript_prettier_options = '--config ~/Projects/datadog/dogweb/static/prettier.config.js'
            " Run formatter on save
            let b:ale_fix_on_save = 1

        " run formatter on save if there is a local prettier bin
        elseif themouette#HasLocalNodeModuleExec('prettier')
            let b:ale_fixers = ['prettier']
            let b:ale_fix_on_save = 1
        endif

    endif

    if count(['python'],&filetype)
        " Autofix python code
        " This will not be triggered if black is not in the path
        let b:ale_fix_on_save = 1
        let b:ale_fixers = { 'python': ['black'] }

        " Force local configuration file to be able to open file outside of
        " `dogweb` dir.
        if themouette#IsDataDogProject()
            let b:python_black_options = '--config ~/Projects/datadog/dogweb/pyproject.toml'
        endif
    endif
endfunction

" Clear auto command group
augroup ale_register_setup
    autocmd!
augroup END

" On every BufEnter, we configure the plugin
" BufEnter allows to have an augroup for each buffer
autocmd ale_register_setup BufEnter  * call RegisterMyAleSetup()
