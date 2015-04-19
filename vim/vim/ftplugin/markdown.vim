" Auto remove tailing spaces
autocmd BufWritePre *.markdown,*.md,*.mkd :call StripTrailingWhitespace()

