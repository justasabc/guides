# http://steve-parker.org/sh/test.shtml
# read
echo "What's your name"
read USER_NAME
echo "Hello $USER_NAME"
echo "I will create a file ${USER_NAME}_file"
touch "${USER_NAME}_file"

# conditional
T1="foo"
T2="bar"
# notice space arround operator [ 
# if SPACE [ SPACE "$foo" SPACE = SPACE "bar" SPACE ]
# if [ $T1 = $T2 ];then
if [ $T1 = $T2 ]
then
	echo "true"
else
	echo "false"
fi

# for loop
for i in 1 2 3 4 5
do
	echo "Looping...number $i"
done

#for i in $(ls); 
for i in `ls`; 
do
	echo item: $i
done


echo "-----------------"
if [ !$1 ];then
	echo "please input variables"
	exit 1
fi
echo $0 $1 $2 $#
echo $@
echo $*
echo $?

while [ "$#" -gt "0" ]
do	
	echo "value is $1"
	shift
done
