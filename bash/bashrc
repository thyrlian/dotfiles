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