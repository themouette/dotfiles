" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup UltiSnips snippets directories. This emulates a plugins behavior
"
" Argument: N/A
"
" Return: {void}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RegisterMyUltiSnipsSetup()
    " Always use the global plugins
    let b:UltiSnipsSnippetDirectories = ["UltiSnips"]

    if &filetype =~# 'javascriptreact'
        UltiSnipsAddFiletypes javascriptreact.javascript.react
    endif
    if &filetype =~# 'typescriptreact'
        :UltiSnipsAddFiletypes typescriptreact.typescript.react
    endif

    if themouette#IsDataDogProject()
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/jest")
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/react")
        return
    endif

    if themouette#IsGandiOrCaliopenProject()
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/react")
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/mocha")
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/gandi")
        return
    endif

    if themouette#HasLocalNodeModule('react')
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/react")
    endif

    if themouette#HasLocalNodeModule('jest')
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/jest")
    endif

    if themouette#HasLocalNodeModule('mocha')
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/mocha")
    endif
endfunction

" Clear auto command group
augroup themouette_plugins_ultisnips_enter
    autocmd!
augroup END

" On every BufEnter, we configure the plugin
" BufEnter allows to have an augroup for each buffer
autocmd themouette_plugins_ultisnips_enter BufEnter  * call RegisterMyUltiSnipsSetup()
