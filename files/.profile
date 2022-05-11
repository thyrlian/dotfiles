# <== Private Functions ==> #
REGEX_MATCHES=()
__sync_regex_matches() {
  if [ -n "$BASH_VERSION" ]; then
    REGEX_MATCHES=()
    for i in ${!BASH_REMATCH[@]}; do
      REGEX_MATCHES[$i]="${BASH_REMATCH[$i]}"
    done
  elif [ -n "$ZSH_VERSION" ]; then
    REGEX_MATCHES=()
    for i in {1..$#match}; do
      REGEX_MATCHES[$i]="${match[$i]}"
    done
  else
    return 1
  fi
}

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


# <== GitHub ==> #
# check out the branch from any given pull request
ghchkpr() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 [pr_id]"
    return 1
  fi
  local pr_id=$1
  # check if it's a git repository
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
  local ret_val=$?
  echo "↻ Checking: is a git repo?"
  if [ $ret_val -ne 0 ]; then
    echo "✘ Failed: it's not a git repo"
    return $ret_val
  else
    echo "✔"
  fi
  echo ""
  # check if it's a GitHub repository
  local remote_url=$(git remote -v)
  local regex_github="git@github\.com:([A-Za-z0-9_\-\.]+)/([A-Za-z0-9_\-\.]+)\.git"
  echo "↻ Checking: is a GitHub repo?"
  if [[ $remote_url =~ $regex_github ]]; then
    __sync_regex_matches
    local repo_owner=${REGEX_MATCHES[1]}
    local repo_name=${REGEX_MATCHES[2]}
    echo "✔"
  else
    echo "✘ Failed: it's not a GitHub repo"
    return 1
  fi
  echo ""
  # query the branch name of the given pull request
  local api_url="https://api.github.com/repos/$repo_owner/$repo_name/pulls/$pr_id"
  local regex_status_code="︙StatusCode︙([[:digit:]]+)"
  local regex_branch_name="\"head\":[[:space:]]+\{[[:space:]]+\"label\":[[:space:]]+\"[^\"]+\",[[:space:]]+\"ref\":[[:space:]]+\"([^\"]+)\","
  echo "↻ Retrieve branch info of the PR via GitHub API:"
  echo "  $api_url"
  local response=$(curl -s -w "︙StatusCode︙%{http_code}" $api_url)
  if [[ ( $response =~ $regex_status_code ) && ( __sync_regex_matches || ( ${REGEX_MATCHES[1]} -eq 200 ) ) ]]; then
    echo "✔"
  else
    echo "✘ Failed: there is something wrong with GitHub's API"
    echo $response
    return 1
  fi
  if [[ $response =~ $regex_branch_name ]]; then
    __sync_regex_matches
    local branch_name=${REGEX_MATCHES[1]}
    echo "Branch name: $branch_name"
  else
    echo "✘ Failed: can't find any branch name info"
    echo $response
    return 1
  fi
  echo ""
  # check out the branch of the pull request
  set -x
  git fetch origin pull/$pr_id/head:$branch_name
  { set +x; } 2>/dev/null
  echo ""
  set -x
  git checkout $branch_name
  { set +x; } 2>/dev/null
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
  local name=$1
  local name_first_char=${name:0:1}
  local name_rest_chars=${name:1}
  kill -9 $(ps aux | grep "[$name_first_char]$name_rest_chars" | awk '{print $2}')
}

# remove all extended attributes of given file(s) or directory(ies)
xattrda() (
  del_file_xattrs() {
    echo "--------------------------------------------------"
    tput setaf 6; echo $1; tput sgr0
    xattr $1 | tee /dev/tty | xargs -I {} xattr -d {} $1
    xattr -w "com.apple.metadata:kMDItemWhereFroms" "" $1
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
alias brewery='type brew > /dev/null 2>&1 && ( brew update && brew upgrade && (brew info cask &>/dev/null && brew upgrade --cask || true) && brew cleanup ) || ( echo "Homebrew is not installed :(" && exit 127 )'
