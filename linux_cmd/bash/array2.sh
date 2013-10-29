# Note that the "@" sign can be used instead of the "*" in constructs such as ${arr[*]}, the result is the same except when expanding to the items of the arr within a quoted string. In this case the behavior is the same as when expanding "$*" and "$@" within quoted strings: "${arr[*]}" returns all the items as a single word, whereas "${arr[@]}" returns each item as a separate word.
# The following example shows how unquoted, quoted "*", and quoted "@" affect the expansion (particularly important when the array items themselves contain spaces):

# http://www.thegeekstuff.com/2010/06/bash-array-tutorial/
# http://www.linuxjournal.com/content/bash-arrays
# http://blog.maxiang.net/15-bash-array-tutorial/148/

array=("first item" "second item" "third" "item")

echo "Number of items in original array: ${#array[*]}"
for ix in ${!array[*]}
do
    printf "   %s\n" "${array[$ix]}"
done
echo

arr=(${array[*]})
echo "After * unquoted expansion: ${#arr[*]}"
for ix in ${!arr[*]}
do
    printf "   %s\n" "${arr[$ix]}"
done
echo

arr=(${array[@]})
echo "After @ unquoted expansion: ${#arr[*]}"
for ix in ${!arr[*]}
do
    printf "   %s\n" "${arr[$ix]}"
done
echo

arr=("${array[*]}")
echo "After * quoted expansion: ${#arr[*]}"
for ix in ${!arr[*]}
do
    printf "   %s\n" "${arr[$ix]}"
done
echo

arr=("${array[@]}")
echo "After @ quoted expansion: ${#arr[*]}"
for ix in ${!arr[*]}
do
    printf "   %s\n" "${arr[$ix]}"
done
