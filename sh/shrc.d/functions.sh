#!/bin/bash

# Créer une archive pour un repertoire donne.
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# ex - Extraire une archive
# usage: ex <fichier>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1   ;;
      *.tar.gz)    tar xzvf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xvf $1    ;;
      *.tbz2)      tar xjvf $1   ;;
      *.tgz)       tar xzvf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo -e "${bldred}'$1' ne peut pas etre decompresse avec ex()" ;;
    esac
  else
    echo -e "\n${bldred}'$1' n'est pas un fichier valide"
  fi
}

# clock - Affiche une horloge simple
# usage: clock
clock() { while true;do clear;echo -e "\e[30;1m===========\e[0m\e[01;33m";date +"%r";echo -e "\e[0m\e[30;1m===========\e[0m";sleep 1;done; }

# definef - Definition francaise d'un mot a l'aide de google
# usage: definef <mot>
definef(){ local y="$@";curl -sA"Opera" "http://www.google.fr/search?q=define:${y// /+}"|grep -Po '(?<=<li>)[^<]+'|nl|perl -MHTML::Entities -pe 'decode_entities($_)' 2>/dev/null;}
 
# define - Definition Anglaise d'un mot a l'aide de google
# usage: definef <word>
define(){ local y="$@";curl -sA"Opera" "http://www.google.com/search?q=define:${y// /+}"|grep -Po '(?<=<li>)[^<]+'|nl|perl -MHTML::Entities -pe 'decode_entities($_)' 2>/dev/null;}

# resetperm - restaurer les permissions des repertoires et fichiers avec leurs valeurs "normales" (644/755)
# usage: resetperm <dossier>
resetperm()
{
  chmod -R u=rwX,go=rX "$@"
  chown -R ${USER}:users "$@"
}

# XXX - mise en forme des permissions symbolic en octal (644)
# usage : ls -l | XXX
XXX() { sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g'  -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g' ; }

# Convertir l'encodage d'un fichier iso2utf8/utf82iso
# usage : changeEncoding <fichier>
changeEncoding()
{
  if [ -f "$1" ] ; then
    case "`file -bi "$1"`" in
      *iso-8859-1)   iconv --from-code=ISO-8859-1 --to-code=UTF-8 "$1" > "$1".utf-8 && echo -e "\n${bldgrn}Nouveau fichier : "$1".utf-8"  ;;
      *utf-8)   iconv --from-code=UTF-8 --to-code=ISO-8859-1 "$1" > "$1".iso-8859-1 && echo -e "\n${bldgrn}Nouveau fichier : "$1".iso-8859-1" ;;
      *us-ascii)   echo -e "\n${bldylw}Encodage US-ASCII pas besoin de convertir"   ;;
      *)           echo -e "\n${bldred}L'encodage de '$1' ne peut pas etre converti avec changeEncoding(`file -bi "$1"`)" ;;
    esac
  else
    echo -e "\n${bldred}'$1' n'est pas un fichier valide"
  fi
}

# Afficher une quote depuis danstonchat.com
# usage: dtc
dtc()
{ 
  url=http://danstonchat.com/random.html?toto=`date +%N` 
  lynx --dump --display_charset=utf8 $url 2>&1 \
    | awk '$1~"#" && $0!~"RSS" { getline; while ($1!~"#") { print $0; getline;}; exit}'
}

# télecharger un site complet avec Wget
# Les pages seront mise en html (E), les liens seront transformés (k) et c'est récursif (r) sur 5 niveaux maxi (l5)
# Usage wdl <URL>
# tip : utiliser servethis pour servir les pages télechargées
wdl(){ wget -r -l5 -k -E ${1} && cd $_;}

# Prendre une capture d'écran
# Usage: screenshot [delai en sc] [qualite]
screenshot() {
    if ! which scrot &>/dev/null; then
        echo "${FUNCNAME[0]}(): Vous devez d'abord installer 'scrot'."
        return 1
    fi
 
    local delay=1
    local quality=95
 
    [ "$1" ] && delay="$1"
    [ "$2" ] && quality="$2"
 
    scrot -q $quality -d $delay "$HOME/screenshot_`date +'%F_%Hh%M'`.jpg"
}

# Transforme une image (depuis une URL) en ascci html
# servethis pour voir sur le port 8000 ou mongoose http://code.google.com/p/mongoose/
# usage : toascii <URL>
toascii() { convert $1 jpg:- | jp2a - --color --fill --background=light --html > $HOME/ascii_`date +'%F_%Hh%M'`.html;}

# Construire une galerie html avec toutes les photo d'un dossier
# usage : galerie
galerie() 
{
  OLDIFS="$IFS"
  IFS=$'\n' # don't split on any white space
  DIRECTORY="$1"
  if [[ -z "$DIRECTORY" ]]; then
      DIRECTORY="."
  fi
  echo -e "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1- \
transitional.dtd\">\n<HTML>\n<head>\n<title>Galerie photo du `date +'%F_%Hh%M'`</title>\n\n<style type=\"text/css\">\nhtml \
, body {\n\tmargin: 0px;\n\tpadding: 0px;\n\tborder: 0px;\n}\n#main {\n\tmargin: 5px 20px;\n}\ndiv.left {\n\tfloat: left;\n\tmargin \
-right: 300px;\n\twidth: 400px;\n\tmargin-bottom: 10px;\n}\ndiv.left p {\n\ttext-align: center;\n}\nimg {\n\tborder: 0px none;\n}\ndiv. \
center {\n\twidth: 600px;\n}\n.clear {\n  clear : both;\n}\n</style>\n</head>\n\n<body>\n<div id=\"main\">\n  <h1>Galerie photo du \
 `date +'%F_%Hh%M'`</h1>\n" > galerie_`date +'%F'`.html;
  for i in `find $DIRECTORY -regex ".*\.\(jpg\|jpeg\|png\|gif\|JPG\|JPEG\|PNG\|GIF\)"`
  do
      echo -e "\t<div class="left">\n\t\t<a href=\"${i}\"><img src=\"${i}\" width="300" height="300" border="0" /></a><br />\n\t\t<p>${i}</p>\n\t</div>\n" >> galerie_`date +'%F'`.html
  done
  echo -e "</div>\n</body>\n</html>" >> galerie_`date +'%F'`.html
  echo -e "\n${bldgrn}La galerie galerie_`date +'%F'`.html contient les photos du dossier `pwd`."
  IFS=$OLDIFS # restore IFS
}

# chext - modifier l'extension 
# usage : chext new_ext *.old_ext
function chext(){
  local fname
  local new_ext="$1"
  shift
  IFS=$'\n'
  for fname in $@
  do
    mv "$fname" "${fname%.*}.$new_ext"
  done
}

# cbt - Count by Type - affiche le nombre de fichiers par type
# usage : cbt
cbt() { find ${*-.} -type f -print0 | xargs -0 file | awk -F, '{print $1}' | awk '{$1=NULL;print $0}' | sort | uniq -c | sort -nr ;}

# Renomme en minuscules
# usage tolowercase <*.txt>
toLowercase() { for i in "$@"; do mv -f "$i" "`echo $i| tr [A-Z] [a-z]`" &>/dev/null; done }
 
# Renomme en majuscules
# usage toupercase <*.txt>
toUpercase() { for i in "$@"; do mv -f "$i" "`echo $i| tr [a-z] [A-Z]`" &>/dev/null; done }

# remplacer les espaces par des _
# usage underscorespace <*.txt>
underscorespace() { for i in "$@"; do mv "$i" "`echo $i| tr ' ' '_'`" &>/dev/null; done }

# tempsrep - temps de réponse pour un URL
# usage : tempsrep <URL> (TTFB:time to first bit)
tempsrep() { curl -o /dev/null -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n" $1; }

# getserver - Determine le serveur utilisé par un site 
# usage : getserver <URL> 
getserver() { curl -I $1  2>&1 | grep Server;}

txtrst='\e[0m'    # Text Reset
txtcyn="\033[01;36m" # turquoise, heure prompt
txtpur="\033[01;32m" # turquoise, heure prompt

# Affiche une liste des fonctions comme alias le fait pour les alias
fonctions()
{
  echo -e "\n${txtpur}FONCTIONS
----------------------------------------------------------------------${txtrst}"
  echo -e "${txtcyn}mktar() <dossier> :${txtrst} creer une archive tar du dossier"
  echo -e "${txtcyn}mktgz() <dossier> :${txtrst} creer une archive tar.gz du dossier"
  echo -e "${txtcyn}mktbz() <dossier> :${txtrst} creer une archive tar.bz2 du dossier"
  echo -e "${txtcyn}ex <fichier> :${txtrst} extraire un fichier"
  echo -e "${txtcyn}clock :${txtrst} Affiche une horloge simple"
  echo -e "${txtcyn}definef <mot> :${txtrst} Definition francaise d'un mot a l'aide de google"
  echo -e "${txtcyn}define <word> :${txtrst} Definition anglaise d'un mot a l'aide de google"
  echo -e "${txtcyn}resetperm <dossier> :${txtrst} restaurer les permissions des repertoires et fichiers avec leurs valeurs normales (644/755)"
  echo -e "${txtcyn}ls -l | XXX :${txtrst} XXX - mise en forme des permissions symbolic en octal (644)"
  echo -e "${txtcyn}changeEncoding <fichier>:${txtrst} Convertir l'encodage d'un fichier iso2utf8/utf82iso"
  echo -e "${txtcyn}dtc :${txtrst} affiche une quote depuis danstonchat.com"
  echo -e "${txtcyn}wdl <URL> :${txtrst} telecharger un site complet avec Wget"
  echo -e "${txtcyn}toascii <URL> :${txtrst} Transforme une image (depuis une URL) en ascci html"
  echo -e "${txtcyn}screenshot [delai en sc] [qualite] :${txtrst} prendre une capture d'ecran"
  echo -e "${txtcyn}toascii <URL> :${txtrst} tranforme une image en ascii html"
  echo -e "${txtcyn}galerie :${txtrst} Construire une gallerie html avec toutes les photo d'un dossier"
  echo -e "${txtcyn}chext new_ext *.old_ext :${txtrst} modifier l'extension" 
  echo -e "${txtcyn}cbt (Count by Type) :${txtrst} affiche le nombre de fichiers par type" 
  echo -e "${txtcyn}toLowercase <*.txt> :${txtrst} renommer en minuscules" 
  echo -e "${txtcyn}toUpercase <*.txt> :${txtrst} renommer en majuscules" 
  echo -e "${txtcyn}underscorespace <*.txt>:${txtrst} remplacer les espaces par des _"
  echo -e "${txtcyn}tempsrep <URL> :${txtrst} temps de reponse pour un URL" 
  echo -e "${txtcyn}getserver <URL> :${txtrst} Determine le serveur utilise par un site"
}

function bashtips {
echo -e "
${txtpur}REPERTOIRES
----------------------------------------------------------------------${txtrst}
${txtcyn}~-          ${txtrst}repertoire precedent
${txtcyn}pushd tmp   ${txtrst}Push tmp && cd tmp
${txtcyn}popd        ${txtrst}Pop && cd
${txtcyn}save foo    ${txtrst}bookmark le dossier courant dans foo
${txtcyn}show        ${txtrst}voir une liste des bookmarks
 
${txtpur}HISTORIQUE
----------------------------------------------------------------------${txtrst}
${txtcyn}!!        ${txtrst}Derniere commande
${txtcyn}!!:p      ${txtrst}Apercu sans execution de la derniere commande
${txtcyn}!?foo     ${txtrst}Derniere commande contenant \`foo'
${txtcyn}^foo^bar^ ${txtrst}Derniere commande contenant \`foo', mais substitue avec \`bar'
${txtcyn}!!:0      ${txtrst}Derniere commande mot
${txtcyn}!!:^      ${txtrst}1er argument de la derniere commande
${txtcyn}!\$        ${txtrst}Dernier argument de la derniere commande
${txtcyn}!!:*      ${txtrst}Tout les arguments de la derniere commande
${txtcyn}!!:x-y    ${txtrst}Arguments x a y de la derniere commande
${txtcyn}[Ctrl]-s  ${txtrst}Rechercher en avant dans l'historique
${txtcyn}[Ctrl]-r  ${txtrst}Rechercher en arriere dans l'historique
 
${txtpur}EDITION DE LIGNE
----------------------------------------------------------------------${txtrst}
${txtcyn}[Ctrl]-a     ${txtrst}aller au debut de la ligne
${txtcyn}[Ctrl]-e     ${txtrst}aller a la fin de la ligne
${txtcyn}[ Alt]-d     ${txtrst}efface jusqu'a la fin d'un mot
${txtcyn}[Ctrl]-w     ${txtrst}efface jusqu'au debut d'un mot
${txtcyn}[Ctrl]-k     ${txtrst}efface jusqu'a la fin de la ligne
${txtcyn}[Ctrl]-u     ${txtrst}efface jusqu'au debut de la ligne
${txtcyn}[Ctrl]-y     ${txtrst}coller le contenu du buffer
${txtcyn}[Ctrl]-r     ${txtrst}revert all modifications to current line
${txtcyn}[Ctrl]-]     ${txtrst}chercher en avant dans la ligne
${txtcyn}[ Alt]-
${txtcyn}[Ctrl]-]   ${txtrst}chercher en arriere dans la ligne
${txtcyn}[Ctrl]-t     ${txtrst}switch lettre
${txtcyn}[ Alt]-t     ${txtrst}switch mot
${txtcyn}[ Alt]-u     ${txtrst}mot en Majuscule
${txtcyn}[ Alt]-l     ${txtrst}Mot en Minuscule
${txtcyn}[ Alt]-c     ${txtrst}1ere lettre du mot en Majuscule
 
${txtpur}COMPLETION
----------------------------------------------------------------------${txtrst}
${txtcyn}[ Alt].      ${txtrst}faire defiler les arguments de la derniere commande
${txtcyn}[ Alt]-/     ${txtrst}completer le nom de fichier
${txtcyn}[ Alt]-~     ${txtrst}completer le nom d'utilisateur
${txtcyn}[ Alt]-@     ${txtrst}completer le nom d'host
${txtcyn}[ Alt]-\$     ${txtrst}completer le nom de variable
${txtcyn}[ Alt]-!     ${txtrst}completer le nom d'une commande
${txtcyn}[ Alt]-^     ${txtrst}completer l'historique"
 
}
