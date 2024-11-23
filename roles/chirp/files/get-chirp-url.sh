#!/usr/bin/env bash

# Fetch the URL and follow redirects, storing the base URL in a variable
final_url=$(curl -Ls -o /dev/null -w %{url_effective} "https://archive.chirpmyradio.com/download?stream=next")

# Fetch the content of the final URL
content=$(curl -Ls "$final_url")

# Use regex to extract the string similar to "chirp-20240807-py3-none-any.whl"
# The regex pattern looks for "chirp-", then any 8 digit number, followed by "-py3-none-any.whl"
extracted_string="$(echo "$content" | grep -oP -m1 'chirp-\d{8}-py3-none-any\.whl' | head -n1)"

# Print the concatenated final URL and the extracted string
if [[ -n "$extracted_string" ]]; then
    echo "${final_url}${extracted_string}"
else
   exit 1
fi
