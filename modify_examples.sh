#!/bin/sh
# Script for testing Task 1 for Operative Systems
# Version 1.0

echo "modify.sh testing..."

echo "Test 1: showing help..."
./modify.sh --help

echo "Test 2: testing no argument given..."
./modify.sh

echo "Test 3: testing no filename given (lower)..."
./modify.sh -l

echo "Test 4: testing no filename given (upper)..."
./modify.sh -u

echo "Test 5: testing no filename given (recursive)..."
./modify.sh -r

echo "Test 6: testing no file error (lower)..."
./modify.sh -l no_file.txt

echo "Test 7: testing no file error (recursive)..."
./modify.sh -u no_file.txt

echo "Test 8: testing upper...."
./modify.sh -u prueba.txt

echo "Test 9: testing lower..."
./modify.sh -l PRUEBA.TXT

echo "Test 10: testing uppper with full path..."
./modify.sh -u TestDir/abc.txt

echo "Test 11: testing lower with full path..."
./modify.sh -l TestDir/ABC.TXT

echo "Test 12: testing uppper to directory..."
./modify.sh -u TestDir/

echo "Test 13: testing lower to directory..."
./modify.sh -l TestDir/

echo "Test 14: testing uppper with many arguments..."
./modify.sh -u prueba.txt TestDir/abc.txt TestDir/TestDir2/TestDir3/

echo "Test 15: testing lower with full path..."
./modify.sh -l PRUEBA.TXT TestDir/ABC.TXT TestDir/TestDir2/TestDir3/

echo "Test 16: testing uppper with recursivity..."
./modify.sh -r -u TestDir/

echo "Test 17: testing lower with recursivity..."
./modify.sh -r -l TestDir/

echo "Test 18: testing upper with recursivity in many directories..."
./modify.sh -r -u TestDir/TestDir2/TestDir3/ TestDir/

echo "Test 19: testing lower with recursivity in many directories..."
./modify.sh -r -l TestDir/TestDir2/TestDir3/ TestDir/

echo "Test 20: testing bad sed pattern..."
./modify.sh qwerty TestDir/

echo "Test 21: testing bad directory..."
./modify.sh s/abc/cba/g no_directory/

echo "Test 22: testing sed pattern..."
./modify.sh s/abc/cba/g TestDir/TestDir2/TestDir3/

echo "Test 23: testing sed pattern..."
./modify.sh s/cba/abc/g TestDir/TestDir2/TestDir3/

echo "Test 24: testing sed pattern in recursivity..."
./modify.sh -r s/abc/cba/g TestDir/TestDir2/TestDir3/

echo "Test 25: testing sed pattern in many directories..."
./modify.sh -r s/cba/abc/g TestDir/

echo "Test 26: testing sed pattern in many directories..."
./modify.sh -r s/abc/cba/g TestDir/TestDir2/TestDir3/ TestDir/
