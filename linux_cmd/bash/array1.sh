# http://www.linuxjournal.com/content/bash-arrs
arr=(hello world kezunlin)
# Wrong
echo "wrong..."
echo $arr[0]
echo $arr[1]
# Right
# The braces are required to avoid conflicts with pathname expansion.
echo "right..."
echo ${arr[0]}
echo ${arr[1]}
echo "advanced..."
echo ${arr[*]}         # All of the items in the arr
# hello world kezunlin
echo ${!arr[*]}        # All of the indexes in the arr
# 0 1 2
echo ${#arr[*]}        # Number of items in the arr
# 3
echo "item arr 0"
echo ${#arr[0]}        # Length of item zero
# 5

echo "for loop using *"
echo "arr size: ${#arr[*]}"

echo "arr items:"
for item in ${arr[*]}
do
    printf "   %s\n" $item
done

echo "arr indexes:"
for index in ${!arr[*]}
do
    printf "   %d\n" $index
done

echo "arr items and indexes:"
for index in ${!arr[*]}
do
    printf "%4d: %s\n" $index ${arr[$index]}
done

echo "for loop using @"
echo "arr size: ${#arr[@]}"

echo "arr items:"
for item in ${arr[@]}
do
    printf "   %s\n" $item
done

echo "arr indexes:"
for index in ${!arr[@]}
do
    printf "   %d\n" $index
done

echo "arr items and indexes:"
for index in ${!arr[@]}
do
    printf "%4d: %s\n" $index ${arr[$index]}
done


