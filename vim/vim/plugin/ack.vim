" Setup [mileszs/ack.vi](https://github.com/mileszs/ack.vim)
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
endif
