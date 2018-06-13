#!/bin/bash
TEST_FOLDER=$(dirname "$0")
if [ $# -gt 0 ]
  then
    TEST_FOLDER=$1
fi
RETURN_CODE=0;
for testfile in $(find $TEST_FOLDER -iname "*_test.rb" | sort);
  do
    ruby $testfile;
    if [ $? -ne 0 ];
      then
        RETURN_CODE=1;
    fi;
done;
if [ $RETURN_CODE -ne 0 ];
  then
    exit 1;
fi;
