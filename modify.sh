#!/bin/sh
# Script for Task 1 for Operative Systems
# simple version

# the name of the script without a path
name=`basename $0`

# function for printing error messages to diagnostic output
error_msg()
{
       echo "$name: error: $1" 1>&2
}

# function for help, using -h|--help option
show_help()
{
       if test -z "$1"
       then
               error_msg "missing argument for -w"
               exit 1
       fi
       echo "-w with argument: $1"
}


# if no arguments given
if test -z "$1"
then
cat<<EOT 1>&2

usage:
 $name [-r|--recursive] [-l|--lowercase]|[-s|--uppercase] [-h|--help] <names>

$name correct syntax examples:
 $name -l new.c
 $name -r --uppercase directory
 $name --help

$name incorrect syntax example:
 $name -d

EOT
fi


# do with command line arguments
l=n
u=n
r=n
while test "x$1" != "x"
do
       case "$1" in
               -r|--recursive) r=y;;
               -l|--lowercase) l=y;;
               -u|--uppercase) u=y;;
               -h|--help) show_help "$2"; shift;;
               -*) error_msg "bad option $1"; exit 1 ;;
               *) fullpath="$1";;
       esac
       shift
done
if test $l = "y" && test $r = "n"
then
       echo "Rename $fullpath with option --lowercase"
       path=$(echo "${fullpath%/*}/")
       filename=$(echo "${fullpath##*/}")
       filename_l=$(echo "$filename" | tr 'A-Z' 'a-z')
       mv "$path$filename" "$path$filename_l"
       if test $? = 0
       then
         echo "File $filename_l was ranamed successfully"
       else
         echo "File $filename can't be renamed"
       fi
fi
if test $u = "y" && test $r = "n"
then
       echo "Rename $fullpath with option --uppercase"
       path=$(echo "${fullpath%/*}/")
       filename=$(echo "${fullpath##*/}")
       filename_u=$(echo "$filename" | tr 'a-z' 'A-Z')
       mv "$path$filename" "$path$filename_u"
       if test $? = 0
       then
         echo "File $filename_u was ranamed successfully"
       else
         echo "File $filename can't be renamed"
       fi
fi
if (test $r = "y" && test $u = "y") || ( test $r = "y" && test $l = "y")
then
       echo "Rename $fullpath directory with option --recursive"
       path=$(echo "${fullpath%/*}/")
       cd $path
       for filename in *.*
       do
         if test $u = "y"
         then
           filename_r=$(echo "$filename" | tr 'a-z' 'A-Z')
         fi
         if test $l = "y"
         then
           filename_r=$(echo "$filename" | tr 'A-Z' 'a-z')
         fi
         mv "$filename" "$filename_r"
         if test $? = 0
         then
           echo "File $filename_r was ranamed successfully"
         else
           echo "File $filename can't be renamed"
         fi
       done

else
  error_msg "bad option recursive without uppercase or lowercase"
  exit 1
fi
