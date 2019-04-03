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
  echo "Rename $1 with option --uppercase"
  if (test -f $1)
  then
    path=$(echo "${1%/*}/")
    filename=$(echo "${1##*/}")
    filename_u=$(echo "$filename" | tr 'a-z' 'A-Z')
    mv "$path$filename" "$path$filename_u"
    if test $? = 0
    then
      echo "File $filename_u was renamed successfully"
    else
      echo "File $filename can't be renamed"
    fi
  else
    error_msg "the argument is not a file"
  fi
}

toLower()
{
  echo "Rename $1 with option --lowercase"
  if (test -f $1)
  then
    path=$(echo "${1%/*}/")
    filename=$(echo "${1##*/}")
    filename_l=$(echo "$filename" | tr 'A-Z' 'a-z')
    mv "$path$filename" "$path$filename_l"
    if test $? = 0
    then
      echo "File $filename_l was renamed successfully"
    else
      echo "File $filename can't be renamed"
    fi
  else
    error_msg "the argument is not a file"
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
          toUpper "${filename}"
        fi
        if test $l = "y"
        then
          toLower "${filename}"
        fi
      else
        recursively "${filename}"
      fi
    done
  else
    if (test -n $1)
    then
      error_msg "Folder '$1' doesn't exist"
    fi
  fi
  shift
}

recursively_sed()
{
  if test -z $1
  then
    break
  fi
  if (test -f "$1")
  then
    error_msg "a file can't be renamed recursively"
  elif (test -d "$1")
  then
    for filename in "$1"/*
    do
      if test -f "$filename"
      then
        sed_patern "${filename}"
      else
        recursively_sed "${filename}"
      fi
    done
  else
      error_msg "Folder '$1' doesn't exist"
  fi
  shift
}


sed_patern()
{
  path=$(echo "${1%/*}/")
  newFilename=$(echo "${1##*/}" | sed "$argument")
  if test $? != 0
  then
    error_msg "sed pattern '$argument' wrong, see man sed to help"
  else
    if test "$path$newFilename" != "$1"
    then
      echo "Rename $1 with option sed pattern $argument"
      mv "$1" "$path$newFilename"
      if test $? = 0
      then
        echo "File $newFilename was ranamed successfully"
      else
        echo "File $filename can't be renamed"
      fi
    else
      echo "File $1 hasn't changed"
    fi
  fi
}

# function for help, using -h|--help option
show_help()
{
cat<<EOT

usage:
 $name [-r|--recursive] [-l|--lowercase]|[-s|--uppercase] [-h|--help] <names>

Change to uppercase or lowercase the filenames given by arguments

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
      recursively "$argument"
    else
      shift
      recursively_sed "$@"
    fi
  else
    if (test $u = "y" || test $l = "y")
    then
      if (test $u = "y")
      then
        if test -f "$argument"
        then
          toUpper "$argument"
        else
          for filename in "$argument"/*
          do
            if test -f "$filename"
            then
              toUpper "$filename"
            fi
          done
        fi
      fi
      if (test $l = "y")
      then
        if test -f "$argument"
        then
          toLower "$argument"
        else
          for filename in "$argument"/*
          do
            if test -f "$filename"
            then
              toLower "$filename"
            fi
          done
        fi
      fi
    else
      shift
      for filename in "$@"
      do
        if test -f "$filename"
        then
          sed_patern "$1"
        else
          for filename_inside in "$filename"/*
          do
            if test -f "$filename_inside"
            then
              sed_patern "$filename_inside"
            fi
          done
        fi
      done
    fi
  fi

  # flag to show error if no argument given
  execution=y
}

# if no arguments given
if test -z "$1"
then
  echo "$name: error: no arguments given see --help"
  show_help
fi

# do with command line arguments
while test "x$1" != "x"
do
       case "$1" in
               -r|--recursive) r=y;;
               -l|--lowercase) l=y;;
               -u|--uppercase) u=y;;
               -h|--help) show_help; shift;;
               -*) error_msg "bad option $1"; exit 1 ;;
               *) argument="$1"; checking $@;;
       esac
       shift
done

if (test $execution = "n")
then
  error_msg "no filename or directory given see help, --help"
fi
