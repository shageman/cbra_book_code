#!/bin/bash

result=0

echo "### TESTING EVERYTHING WITH TEAMS DB"

rm components/teams
ln -s teams_implementations/teams_db components/teams

for test_script in $(find . -name test.sh); do
  pushd `dirname $test_script` > /dev/null
  ./test.sh
  result+=$?
  popd > /dev/null
done

echo "### TESTING EVERYTHING WITH TEAMS IN MEM"

rm components/teams
ln -s teams_implementations/teams_mem components/teams

for test_script in $(find . -name test.sh); do
  pushd `dirname $test_script` > /dev/null
  ./test.sh
  result+=$?
  popd > /dev/null
done

if [ $result -eq 0 ]; then
	echo "SUCCESS"
else
	echo "FAILURE"
fi

exit $result
