#!/bin/bash
input_file="$1"
num_cols=$(head -1 "$input_file" | wc -w)
for i in $(seq 1 "$num_cols"); do
echo $(cut -d ' ' -f "$i" "$input_file")
done


# Convert Rows into Columns and Columns into Rows
# File has below conent:
# name age
# alice 21
# ryan 30
#Now converting it to
# name alice ryan
# age 21 30