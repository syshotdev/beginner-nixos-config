# !/bin/bash

# How this script works: It has a list of banned words, it recursively searches the entire project
# in search of these banned words, and if it finds them it alerts you to exactly where.
#
# Put a bannedwords.txt in this directory
#
# Useful for keeping identities/secrets separate
#
# I should probably allow an environment variable for the bannedwords. Oh well..

program_name=$0
# Determine the directory where the script is located
script_dir=$(dirname "$(readlink -f "$0")")


usage() {
  cat << EOF >&2
Usage: $program_name directory_to_check [-b]
 -b: bannedwords file
EOF
  exit 1
}

banned_words="$script_dir/bannedwords.txt"
while getopts "b:" opt; do
  case $opt in
    b) banned_words="$OPTARG";; # Bannedwords.txt as a commandline argument
    \?) usage;;
    :) echo "Option -$OPTARG requires argument." >&2
        exit 1;;
  esac
done
# Shift the processed options out of the way
shift $((OPTIND-1))

path=${1:-$PWD} # If path supplied, use that. Otherwise use current terminal path

# Example find command or other operations (modify as needed)
echo "Using path: $path"
echo "Using bannedwords file: $banned_words"

if [[ ! -f "$banned_words" ]]; then
  echo "bannedwords.txt not found!"
  exit 1
fi


result=""

# For every word in banned words, do all of this
while IFS= read -r query; do 
  # If the line isn't empty
  if [[ -n "$query" ]]; then
    # In path, find a type (d = dir, f = file), ignore case, matching this regex string
    # Also if didn't find anything don't append a \n
    dir_result=$(find "$path" -type d -iname "*$query*")
    if [[ -n "$dir_result" ]] then
      result+="$dir_result\n"
    fi

    file_result=$(find "$path" -type f -iname "*$query*")
    if [[ -n "$file_result" ]] then
      result+="$file_result\n"
    fi
  fi
done < "$banned_words"

# Search path with bannedwords.txt in mind
# r = recursive, n = print line number, l = stop searching if the FILE has the query, i = ignore case
# f = keywords from file 1 to search for
# Using ripgrep though so r doesn't matter
result+=$(rg -n -i -f "$banned_words" "$path")

# Check if "result" is not empty. This removes the random newlines when no results are found
if [[ -n "$result" ]] then
  echo "$result"
  printf "\n"
fi
