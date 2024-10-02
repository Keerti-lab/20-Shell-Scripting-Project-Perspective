replace a specific string
#!/bin/bash

# Step 1: Find files containing the string 'old_string'
grep -rl 'old_string' /path/to/directory > filelist.txt

# Step 2: Use sed to replace 'old_string' with 'new_string' in the identified files
while IFS= read -r file; do
    sed -i 's/old_string/new_string/g' "$file"
done < filelist.txt



# You need to find and replace a specific string in multiple text files in a directory.
# How would you use shell script accomplish this task?