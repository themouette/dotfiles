" Auto remove tailing spaces
autocmd BufWritePre *.yaml,*.yml :call StripTrailingWhitespace()

