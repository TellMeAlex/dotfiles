# FUNCTIONS

function backup() {
  git add --all
  git commit -am ':wrench: [WIP] Done for today, cya tomorrow [ci skip] :wave:'
  git push $@
}

function git-ignore() {
  curl -L -s https://www.gitignore.io/api/$@ | xclip -sel clip
}

alias gi="git-ignore"

function mkcd () {
  case "$1" in
    */..|*/../) cd -- "$1";; # that doesn't make any sense unless the directory already exists
    /*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1";;
    /*) mkdir -p "$1" && cd "$1";;
    */../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1";;
    ../*) (cd .. && mkdir -p "${1#.}") && cd "$1";;
    *) mkdir -p "./$1" && cd "./$1";;
  esac
}

alias md="mkcd"

function open() {
  xdg-open $@ &
  disown
}

function find-file() {
  local FILE=$(fzf --preview-window=right:60% --preview='bat --color "always" {}')

  if [ ! -z $FILE ]; then
    $EDITOR $FILE
  fi
}

function please() {
  local CMD=$(history -1 | cut -d" " -f4-)
  sudo "$CMD"
}

function weather() {
  curl 'wttr.in/~'${1:-Parbatsar}'+'$2'?'${3:-0}
}

alias m="weather"

# Change cursor shape for different vi modes.
function zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} == '' ]] ||
    [[ $1 == 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

zle -N zle-keymap-select

zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}

zle -N zle-line-init

echo -ne '\e[5 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}

bindkey -s '^o' 'lfcd\n'

shorten() { node ~/code/pika.im/node_modules/.bin/netlify-shortener "$1" "$2"; }
killport() { lsof -i tcp:"$*" | awk 'NR!=1 {print $2}' | xargs kill -9; }

fig() { figlet "$@" | lolcat; }
tm() { toilet -f mono12 "$@" | lolcat; }
tf() { toilet -f future "$@" | lolcat; }
tbg() { toilet -f bigmono12 "$@" | lolcat; }

function ranger-cd() {
  tempfile="$(mktemp -t tmp.XXXXXX)"
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]; then
      cd -- "$(cat "$tempfile")"
    fi
  rm -f -- "$tempfile"
}

function cra() { cp -R ~/.rapp "$@"; cd "$@" }
function crat() { cp -R ~/.rappt "$@"; cd "$@" }
function cna() { cp -R ~/.napp "$@"; cd "$@" }
function cnat() { cp -R ~/.nappt "$@"; cd "$@" }
function cga() { cp -R ~/.gapp "$@"; cd "$@" }
function csa() { cp -R ~/.sapp "$@"; cd "$@" }
function csat() { cp -R ~/.sappt "$@"; cd "$@" }
function csat() { cp -R ~/.sappt "$@"; cd "$@" }
function 3000() { curl http://localhost:3000/"$@"  }
function 3030() { curl http://localhost:3030/"$@"  }
function 3001() { curl http://localhost:3001/"$@"  }
function 4000() { curl http://localhost:4000/"$@"  }
function 3000i() { curl http://localhost:3000/"$@" --include  }
function 3001i() { curl http://localhost:3001/"$@" --include  }
function 4000i() { curl http://localhost:4000/"$@" --include  }

gccd() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

alias gc="gccd"

function issue() {
  local use_pr=false

  # Comprobar si se proporciona el indicador -pr
  if [[ "$1" == "-pr" ]]; then
    use_pr=true
    shift  # Eliminar el indicador -pr del conjunto de argumentos
  fi

  if [ $# -lt 1 ]; then
    echo "Uso: issue [-pr] <ID1> [ID2]" >&2
    return 1
  fi

  local ID1="$1"
  
  if [ "$use_pr" = true ]; then
    local comando="gh sherpa cpr -i MYTEAM-$ID1"
  else
    local comando="gh sherpa cb -i MYTEAM-$ID1"
  fi
  
  if [ $# -eq 2 ]; then
    local ID2="$2"
    
    # Buscar una rama local que contenga el ID2 en su nombre (Seleccionamos solo la primera)
    local matching_branch=$(git branch | grep ".*MYTEAM-$ID2.*")
    
    # Limpiamos espacios en blanco y los saltos de linea
    matching_branch=$(echo "$matching_branch" | tr -d '[:space:]')
    
    # Limpiamos el caracter '*' al inicio de la rama que indica la rama actual en caso de que exista
    matching_branch=$(echo "$matching_branch" | sed 's/*//g')
    
    if [ -n "$matching_branch" ]; then
      comando+=" --base $matching_branch"
    else
      echo "No se encontró una rama local que contenga 'MYTEAM-$ID2'. No se puede realizar la acción." >&2
      return 1
    fi
  fi

  # Ejecutamos el comando
  # echo "El comando que se ejecutará es: $comando"

  eval "$comando"
}