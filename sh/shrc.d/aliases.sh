# http://unix.stackexchange.com/a/194136
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias my_ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias myip6="curl http://ipv6.whatismyip.akamai.com/"
alias my_ip6="curl http://ipv6.whatismyip.akamai.com/"

alias vim-conflict="vim -p \$(git ls-files -m| uniq)"
