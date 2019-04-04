#!/bin/sh
# Script for Task 1 for Operative Systems
# Version 1.2

# the name of the script without a path
name=`basename $0`

# vars to use
execution=n
l=n
u=n
r=n
sed=n
pattern=n

# function for printing error messages to diagnostic output
error_msg()
{
       echo "$name: error: $1" 1>&2
       exit 1
}

# funcion to convert the argument in capital letters
toUpper()
{
  echo "Rename $1 with option --uppercase"
  if (test -f $1)
  then
    path=$(dirname "${1}")
    filename=$(basename "${1}")
    filename_u=$(echo "$filename" | tr 'a-z' 'A-Z')
    if test $filename_u = $filename
    then
      echo "File $1 wasn't updated"
    else
      mv "$path/$filename" "$path/$filename_u"
      if test $? = 0
      then
        echo "File $filename_u was renamed successfully"
      else
        echo "File $filename can't be renamed"
      fi
    fi
  else
    error_msg "the argument is not a file"
  fi
}

# function to convert the argument in lower case
toLower()
{
  echo "Rename $1 with option --lowercase"
  if (test -f $1)
  then
    path=$(dirname "${1}")
    filename=$(basename "${1}")
    filename_l=$(echo "$filename" | tr 'A-Z' 'a-z')
    if test $filename_l = $filename
    then
      echo "File $1 wasn't updated"
    else
      mv "$path/$filename" "$path/$filename_l"
      if test $? = 0
      then
        echo "File $filename_l was renamed successfully"
      else
        echo "File $filename can't be renamed"
      fi
    fi
  else
    error_msg "the argument is not a file"
  fi
}

# function to go over every folder
recursively()
{
  if test -f "$1"
  then
    error_msg "a file can't be renamed recursively"
  elif test -d "$1" && test "$(ls -A $1)"
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
  elif test -d "$1" && test !"$(ls -A $1)"
  then
    echo "Folder $1 empty"
  else
    if (test -n $1)
    then
      error_msg "Folder '$1' doesn't exist"
    fi
  fi
  shift
}

# go over every folder using sed pattern
recursively_sed()
{
  if test -z $1
  then
    break
  fi
  if (test -f "$1")
  then
    error_msg "a file can't be renamed recursively"
  elif test -d "$1" && test "$(ls -A $1)"
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
  elif test -d "$1" && test !"$(ls -A $1)"
  then
    echo "Folder $1 is empty"
  else
      error_msg "Folder '$1' doesn't exist"
  fi
  shift
}

# function to change the name using sed pattern
sed_patern()
{
  path=$(dirname "${1}")
  newFilename=$(basename "${1}"| sed "$pattern")
  if test $? != 0
  then
    error_msg "sed pattern '$pattern' wrong, see man sed to help"
  else
    if test "$newFilename" != "$(basename "${1}")"
    then
      echo "Rename $1 with option sed pattern $pattern"
      mv "$1" "$path/$newFilename"
      if test $? = 0
      then
        echo "File $newFilename was ranamed successfully"
      else
        echo "File $1 can't be renamed"
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
      if test $pattern = "n"
      then
        pattern=$argument
      else
        recursively_sed "$@"
      fi
    fi
  else
    if (test $u = "y" || test $l = "y")
    then
      if (test $u = "y")
      then
        if test -f "$argument"
        then
          toUpper "$argument"
        elif test -d "$argument" && test "$(ls -A $argument)"
        then
          for filename in "$argument"/*
          do
            if test -f "$filename"
            then
              toUpper "$filename"
            fi
          done
        elif test -d "$argument" && test !"$(ls -A $argument)"
        then
          error_msg "directory $argument is empty"
        else
          error_msg "file $argument doesn't exist"
        fi
      fi
      if (test $l = "y")
      then
        if test -f "$argument"
        then
          toLower "$argument"
        elif test -d $argument
        then
          for filename in "$argument"/*
          do
            if test -f "$filename"
            then
              toLower "$filename"
            fi
          done
        elif test -d "$argument" && test !"$(ls -A $argument)"
        then
          error_msg "directory $argument is empty"
        else
          error_msg "file $argument doesn't exist"
        fi
      fi
    else
      if test $# -le 1 && test $sed = "n"
      then
        error_msg "not many arguments given, see help --help"
      fi
      if (test $sed = "y")
      then
        for filename in "$@"
        do
          if test -f "$filename"
          then
            echo "arg: $1"
            sed_patern "${1}"
          elif test -d "$filename" && test "$(ls -A $filename)"
          then
            for filename_inside in "$filename"/*
            do
              if test -f "$filename_inside"
              then
                echo "arg: $filename_inside"
                sed_patern "${filename_inside}"
              fi
            done
          elif test -d "$filename"  && test !"$(ls -A $filename)"
          then
            echo "directory $filename is empty"
          else
            error_msg "directory $filename doesn't exist"
          fi
        done
      fi
      sed=y
      if test $pattern = "n"
      then
        pattern=$argument
      fi
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
               -h|--help) show_help;;
               -*) error_msg "bad option $1, see help --help"; exit 1 ;;
               *) argument="$1"; checking $@;;
       esac
       shift
done

if (test $execution = "n")
then
  error_msg "no filename or directory, or sed pattern given, see help --help"
fi
