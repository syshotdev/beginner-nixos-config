# !/bin/bash

path=${1:-$PWD} # If path supplied, use that. Otherwise use current terminal path

# Determine the directory where the script is located
script_dir=$(dirname "$(readlink -f "$0")")

# Ensure bannedwords.txt exists
if [[ ! -f "$script_dir/bannedwords.txt" ]]; then
  echo "bannedwords.txt not found!"
  exit 1
fi

# Ensure the path variable is not empty and is a directory
if [[ -z "$path" || ! -d "$path" ]]; then
  echo "Invalid directory path!"
  exit 1
fi


result=""

# For every word in banned words, do all of this
while IFS= read -r query; do 
  # If the line isn't empty or doesn't have hashtag then
  if [[ -n "$query" && "$query" != \#* ]]; then
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
done < "$script_dir/bannedwords.txt"

# Search path with bannedwords.txt in mind
# r = recursive, n = print line number, l = stop searching if the FILE has the query, i = ignore case
# f = keywords from file 1 to search for
# Using ripgrep though so r doesn't matter
result+=$(rg -n -i -f "$script_dir/bannedwords.txt" "$path")

echo "$result"
printf "\n"
