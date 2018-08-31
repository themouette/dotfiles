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
function! SetupUltiSnipsFrontend()
    " Always use the global plugins
    let b:UltiSnipsSnippetDirectories = ["UltiSnips"]

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

    if themouette#HasLocalNodeModuleExec('jest')
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/jest")
    endif

    if themouette#HasLocalNodeModuleExec('mocha')
        call add(b:UltiSnipsSnippetDirectories, "UltiSnipsPlugins/mocha")
    endif
endfunction

augroup themouette_plugins_ultisnips
    autocmd!

    "autocmd BufEnter,BufLeave,BufWipeout * call SetupUltiSnipsFrontend()
    autocmd FileType * call SetupUltiSnipsFrontend()
augroup END
