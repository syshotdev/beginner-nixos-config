# !/bin/bash

# How this script works: It has a list of banned words, it recursively searches the entire project
# in search of these banned words, and if it finds them it alerts you to exactly where.
#
# Put a bannedwords.txt in this directory
#
# Useful for keeping identities/secrets separate
#
# I should probably allow an environment variable for the bannedwords. Oh well..


usage() {
  echo "Usage: $0 directory_to_check [-b bannedwords_file]" >&2
  exit 1
}

path=${1:-$PWD} # If path supplied, use that. Otherwise use current terminal path
script_dir=$(dirname "$(readlink -f "$0")")
banned_words="$script_dir/bannedwords.txt"

while getopts "b:" opt; do
  case $opt in
    b) banned_words="$OPTARG";;
    *) usage;;
  esac
done
# Shift the processed options out of the way
shift $((OPTIND-1))


echo "Using path: $path"
echo "Using bannedwords file: $banned_words"

if [[ ! -f "$banned_words" ]]; then
  echo "bannedwords.txt not found!"
  exit 1
fi

start_time_ms=$(date +%s%3N)

found_words=()
filename_results=""
content_results=""

# For every word in banned words, do all of this
while IFS= read -r query; do 
  # Very sorry for the code, it's ChatGPT written and I don't understand it.
  if [[ -n "$query" ]]; then
    # Search for directories and files matching the query
    filename_matches=$(find "$path" -iname ".*$query*" -o -iname "$query*" -print0 | xargs -0 printf "%s\n")
    if [[ -n "$filename_matches" ]]; then
      found_words+=("$query")
      # For each match, format it like "word, path"
      while IFS= read -r match; do
        filename_results+=$(echo "$query, $match\n")
      done <<< "$filename_matches"
    fi

    # Search within file contents, including git ignored ones
    content_matches=$(rg -uuu -n -i "$query" "$path")
    # I've gotten deep into the weeds of programming (what are these hyroglyphics)
    # Regular expression to format ripgrep response to banned_word, /path/to/file, line 10, "{content}"
    content_matches=$(echo "$content_matches" | sed -E "s/^([^:]+):([0-9]+):(.*)$/$query, \1, line \2, \3/")
    if [[ -n "$content_matches" ]]; then
      found_words+=("$query")
      content_results+=$(echo "$content_matches\n")
    fi
  fi
done < "$banned_words"

# If any words were found
if [[ ${#found_words[@]} -gt 0 ]]; then
  # Print banned filenames
  if [[ -n "$filename_results" ]]; then
    echo -e "\nFILE NAMES:"
    echo -e "$filename_results"
  fi
  # Print banned content from text files  
  if [[ -n "$content_results" ]]; then
    echo -e "\nFILE CONTENTS:"
    echo -e "$content_results"
  fi

  # Sort found words and combine duplicates
  unique_words=($(printf "%s\n" "${found_words[@]}" | sort -u))
  echo "Words found: ${unique_words[*]}"
fi

total_files=$(find "$path" -type f -print | wc -l)
end_time_ms=$(date +%s%3N)
elapsed_time_ms=$((end_time_ms - start_time_ms))
echo "-------------------------------"
echo "Files scanned: ${total_files}"
echo "Time elapsed: ${elapsed_time_ms}ms"
