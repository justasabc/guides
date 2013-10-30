# http://www.thegeekstuff.com/2010/06/bash-array-tutorial/

# 1. Declaring an Array and Assigning values
# name[index]=value
# To access an element from an array use curly brackets like ${name[index]}.
Unix[0]='Debian'
Unix[1]='Red hat'
Unix[2]='Ubuntu'
Unix[3]='Suse'

echo ${Unix[1]}

# 2. Initializing an array during declaration
# Syntax:
# declare -a arrayname=(element1 element2 element3)
# If the elements has the white space character, enclose it with in a quotes.

declare -a Unix=('Debian' 'Red hat' 'OpenLinux' 'Suse' 'Fedora')

# 3. Print the Whole Bash Array
echo $Unix # same as ${Unix[0]}
echo ${Unix[*]}
echo ${Unix[@]}

# 4. Length of the Bash Array
echo ${#Unix[@]} #Number of elements in the array

# 5. Length of the nth Element in an Array
echo ${#Unix[0]}  #Length of item 0 
echo ${#Unix[3]}  #Length of item 3

# 6. Extraction by offset and length for an array
echo ${Unix[@]:3:2}
echo ${Unix[*]:3:2}

# 7. Extraction with offset and length, for a particular element of an array
echo ${Unix[2]:0:4}

# 8. Search and Replace in an array elements
echo ${Unix[@]/Suse/KEzunlin world}
echo ${Unix[*]/Suse/KEzunlin world}

# 9. Add an element to an existing Bash Array
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Unix=("${Unix[@]}" "AIX" "HP-UX")
echo ${Unix[7]}

# 10. Remove an Element from an Array
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
unset Unix[3]
echo ${Unix[3]}
echo "-------------------------6"
echo ${#Unix[@]}
echo ${Unix[@]}

# echo 4
pos=3
echo $(($pos+1))

Unix=(${Unix[@]:0:$pos} ${Unix[@]:$(($pos + 1))})
echo ${Unix[@]}

# 11. Remove Bash Array Elements using Patterns
declare -a Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora');
declare -a patter=( ${Unix[@]/Red*/} )
echo ${patter[@]}

# 12. Copying an Array
# Using "${arr[@]}"
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Linux=("${Unix[@]}")
echo ${Linux[1]}
# 'Reb hat'

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Linux=("${Unix[*]}")
echo ${Linux[1]}
# 

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Linux=(${Unix[@]})
echo ${Linux[1]}
# Red

Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Linux=(${Unix[*]})
echo ${Linux[1]}
# Red


# 13. Concatenation of two Bash Arrays
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Shell=('bash' 'csh' 'jsh' 'rsh' 'ksh' 'rc' 'tcsh');

UnixShell=("${Unix[@]}" "${Shell[@]}")
echo ${UnixShell[@]}
echo ${#UnixShell[@]}

# 14. Deleting an Entire Array
Unix=('Debian' 'Red hat' 'Ubuntu' 'Suse' 'Fedora' 'UTS' 'OpenLinux');
Shell=('bash' 'csh' 'jsh' 'rsh' 'ksh' 'rc' 'tcsh');

UnixShell=("${Unix[@]}" "${Shell[@]}")
unset UnixShell
echo ${#UnixShell[@]}

# 15. Load Content of a File into an Array
filecontent=( `cat "logfile" `)

for t in "${filecontent[@]}"
do
	echo $t
done
