" WARNING: This file is not used anymore since I moved away from ctrlp.vim in
" favor of fzf.vim
finish

" ctrlp
" Replaced ctrlp.vim with command-t
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" If none of the default markers (.git .hg .svn .bzr _darcs) are present in a
" project
let g:ctrlp_root_markers = ['package.json', 'setup.py']
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn)|node_modules|DS_Store)$'

" The maximum number of files to scan, set to 0 for no limit
let g:ctrlp_max_files = 0
