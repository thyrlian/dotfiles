# <== Network ==> #
# get wired IP address to the Clipboard
getipwd() {
  ifconfig | tr "\n" "→" | tr "\r" "→" | grep -Eo "→en[[:digit:]].*?active→" | grep -v "en0" | grep -Eo "inet[[:blank:]+]([0-9]{1,3}\.){3}[0-9]{1,3}" | cut -d' ' -f2 | tr -d "\n" | pbcopy && pbpaste
}

# get wireless IP address to the Clipboard
getipwl() {
  ifconfig | tr "\n" "→" | tr "\r" "→" | grep -Eo "→en0.*?→en[[:digit:]]" | grep -Eo "inet[[:blank:]+]([0-9]{1,3}\.){3}[0-9]{1,3}" | cut -d' ' -f2 | tr -d "\n" | pbcopy && pbpaste
}


# <== Git ==> #
# find and view commit details by keyword in comment
gitsw() {
  if [ $# -eq 0 ]; then
    git log
  else
    git log | grep -B 4 "$1"
  fi
}


# <== *nix ==> #
# find file and show its absolute path
getfilepath() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 [filename]"
    return 1
  else
    ls -d -1 $PWD/**/* | grep $1
  fi
}

# kill process by name
killp() {
  name=$1
  name_first_char=${name:0:1}
  name_rest_chars=${name:1}
  kill -9 $(ps aux | grep "[$name_first_char]$name_rest_chars" | awk '{print $2}')
}

# remove all extended attributes of given file(s) or directory(ies)
xattrda() (
  del_file_xattrs() {
    echo "--------------------------------------------------"
    tput setaf 6; echo $1; tput sgr0
    xattr $1 | tee /dev/tty | xargs -I {} xattr -d {} $1
    echo "--------------------------------------------------"
  }
  echo "Removing all extended attributes..."
  for var in "$@"
  do
    if [ -f $var ]; then
      del_file_xattrs $var
    elif [ -d $var ]; then
      find $var -type f -print0 | xargs -0 -I {} $SHELL -c "$(typeset -f del_file_xattrs)"'; del_file_xattrs "$@"' _ {}
    else
      echo "No such file or directory: $var"
      return 1
    fi
  done
)

# <== macOS ==> #
# Keep Homebrew packages up-to-date
alias brewery='type brew > /dev/null 2>&1 && ( brew update && brew upgrade && brew cask upgrade && brew cleanup ) || ( echo "Homebrew is not installed :(" && exit 127 )'
