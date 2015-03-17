#!/bin/bash

result=0

cd "$( dirname "${BASH_SOURCE[0]}" )"

for test_script in $(find . -name build.sh); do
  echo ""
  echo "#############################################################"
  echo `dirname $test_script`
  echo "#############################################################"
  pushd `dirname $test_script` > /dev/null
  ./build.sh
  result+=$?
  popd > /dev/null
done

if [ $result -eq 0 ]; then
	echo "ALL APPLICATIONS WERE A SUCCESS"
else
	echo "ALL APPLICATIONS WERE A FAILURE"
fi

exit $result
