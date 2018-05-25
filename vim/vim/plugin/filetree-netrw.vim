" from https://blog.hellojs.org/configure-vim-from-scratch-efe5cbc1c563
" configure file explorer (netrw)
" absolute width of netrw window
let g:netrw_winsize = -28
" tree-view
let g:netrw_liststyle = 3
" disable baner
let g:netrw_banner=0
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'
" open file in a new tab
let g:netrw_browse_split = 0
" always refresh directory list
let g:netrw_fastbrowse = 0
" map leader+e to explorer

function! <SID>CloseLex()
    :Lex
    call <SID>SetupOpenLex()
endf
function! <SID>OpenLexLocal()
    :25Lex %:p:h
    call <SID>SetupCloseLex()
endf
function! <SID>OpenLexCwd()
    :25Lex.
    call <SID>SetupCloseLex()
endf
function! <SID>SetupCloseLex()
    augroup themouette_plugins_netrw
        autocmd!

        autocmd BufEnter * nnoremap <leader>e :call <SID>CloseLex()<CR>
        autocmd BufEnter * nnoremap <leader>` :call <SID>CloseLex()<CR>
    augroup END

    nnoremap <leader>e :call <SID>CloseLex()<CR>
    nnoremap <leader>` :call <SID>CloseLex()<CR>
endf
function! <SID>SetupOpenLex()
    augroup themouette_plugins_netrw
        autocmd!

        autocmd BufEnter * nnoremap <leader>e :call <SID>OpenLexLocal()<CR>
        autocmd BufEnter * nnoremap <leader>` :call <SID>OpenLexCwd()<CR>
    augroup END

    nnoremap <leader>e :call <SID>OpenLexLocal()<CR>
    nnoremap <leader>` :call <SID>OpenLexCwd()<CR>
endf

call <SID>SetupOpenLex()
