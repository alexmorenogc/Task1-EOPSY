#!/bin/sh

y=n
u=n


recursively()
{
for filename in TestDir/*
do
  echo "filename: $filename"
  if test -d "$filename"
  then
    recursively "TestDir/$filename"
  elif test -f "$filename"
  then
    if test $u = "y"
    then
      echo "upper"
    fi
    if test $l = "y"
    then
      echo "lower"
    fi
  else
    echo "Something was wrong"
  fi
done
}
recursively $1
