"******************************************************************************
" Configure Neoformat
" see https://github.com/sbdchd/neoformat
"******************************************************************************

let b:neoformat_verbose = 0
nnoremap <buffer> <leader>f :Neoformat<cr>


" Register my Neoformat configuration depending on file type
" Argument: N/A
" Return: {void}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RegisterMyNeoformatSetup()
    " Here we can setup things depending on filetype or anything else
    " We can access filetype through `&ft`.
    " To check if filetype is in a list:
    "
    " if count(['c','cpp','python'],&filetype)
    augroup neoformat_buffer_autocmd
        autocmd!
    augroup END

    " Execute logic here to add autocommands:
    "
    " autocmd neoformat_buffer_autocmd:g BufWritePre  <buffer>
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
            let neoformat_prettier_config = {
                    \ 'exe': themouette#FindNodeModulesExec('prettier'),
                    \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
                    \ 'stdin':1
                    \ }
            " Force local configuration file to be able to open file outside of
            " `statics` dir.
            if themouette#IsDataDogProject()
                let neoformat_prettier_config.args = l:neoformat_prettier_config.args +
                    \ [ '--config', '~/Projects/datadog/dogweb/static/prettier.config.js' ]
            endif

            " Set prettier config
            let b:neoformat_javascript_prettier = l:neoformat_prettier_config
            let b:neoformat_typescript_prettier = l:neoformat_prettier_config
            let b:neoformat_css_prettier = l:neoformat_prettier_config
            let b:neoformat_scss_prettier = l:neoformat_prettier_config
            let b:neoformat_less_prettier = l:neoformat_prettier_config
            let b:neoformat_json_prettier = l:neoformat_prettier_config
            let b:neoformat_html_prettier = l:neoformat_prettier_config
            let b:neoformat_yaml_prettier = l:neoformat_prettier_config
            let b:neoformat_markdown_prettier = l:neoformat_prettier_config
        endif

        if themouette#IsDataDogProject()
            " Explicitely use prettier only as datadog has some unused
            " linter configs at root level and it triggers automatically
            let b:neoformat_enabled_javascript = ['prettier']
            let b:neoformat_enabled_typescript = ['prettier']
            let b:neoformat_enabled_json = ['prettier']
            let b:neoformat_enabled_less = ['prettier']
            let b:neoformat_enabled_markdown = ['prettier']
        endif

        " run formatter on save depending on the project
        if themouette#HasLocalNodeModuleExec('prettier')
            " - default: if there is a local prettier bin
            autocmd neoformat_buffer_autocmd BufWritePre <buffer> undojoin | Neoformat
        endif
    endif

    " Auto format is done with ALE in Python
    " if count(['python'],&filetype)
    "     autocmd neoformat_buffer_autocmd BufWritePre <buffer> undojoin | Neoformat
    " endif
endfunction

augroup themouette_plugins_neoformat
    autocmd!
augroup END

" On every BufEnter, we configure the plugin
" BufEnter allows to have an augroup for each buffer
autocmd themouette_plugins_neoformat BufEnter  * call RegisterMyNeoformatSetup()
