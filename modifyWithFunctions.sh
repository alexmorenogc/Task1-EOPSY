#!/bin/sh
# Script for Task 1 for Operative Systems
# Version 1.1

# the name of the script without a path
name=`basename $0`

# vars to use
execution=n
l=n
u=n
r=n

# function for printing error messages to diagnostic output
error_msg()
{
       echo "$name: error: $1" 1>&2
       show_help
}

toUpper()
{
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
}

toLower()
{
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
}

recursively()
{
  if test -f "$1"
  then
    error_msg "a file can't be renamed recursively"
  elif test -d "$1"
  then
    for filename in "$1"/*
    do
      if test -f "$filename"
      then
        if test $u = "y"
        then
          fullpath="$filename"
          toUpper
        fi
        if test $l = "y"
        then
          fullpath="$filename"
          toLower
        fi
      else
        recursively "${filename}"
      fi
    done
  else
    error_msg "Something was wrong"
  fi
  shift
}

# function for help, using -h|--help option
show_help()
{
cat<<EOT

usage:
 $name [-r|--recursive] [-l|--lowercase]|[-s|--uppercase] [-h|--help] <names>

$name correct syntax examples:
 $name -l filename.txt
 $name -r --uppercase directory
 $name --help

$name incorrect syntax example:
 $name -d

EOT

exit 1
}

# checking conditions
checking()
{
  if (test $r = "y")
  then
    if (test $u = "y" || test $l = "y")
    then
      recursively "$fullpath"
    else
      error_msg "error: bad option, no -u or -l"
    fi
  else
    if (test $u = "y" || test $l = "y")
    then
      if [[ test $u = "y" ]]; then
        toUpper
      fi
      if [[ test $l = "y" ]]; then
        toLower
      fi
    else
      error_msg "error: bad option, no -u or -l"
    fi
  fi

  # flag to show error if no argument given
  execution=y
}

# if no arguments given
if test -z "$1"
then
  echo "$name: error: no arguments given see --help"
fi

# do with command line arguments
while test "x$1" != "x"
do
       case "$1" in
               -r|--recursive) r=y;;
               -l|--lowercase) l=y;;
               -u|--uppercase) u=y;;
               -h|--help) show_help "$2"; shift;;
               -*) error_msg "bad option $1"; exit 1 ;;
               *) fullpath="$1"; checking;;
       esac
       shift
done

if (test $execution = "n")
then
  error_msg "no filename or directory given see help, --help"
fi
