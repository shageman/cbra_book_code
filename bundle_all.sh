#!/bin/bash

# ./c2s02/bundle_gem/Gemfile
# ./c2s02/full_engine/Gemfile
# ./c2s02/full_mountable_engine/Gemfile
# ./c2s02/mountable_engine/Gemfile
# ./c2s02/plain_plugin/Gemfile
# ./c2s02/plain_plugin_rspec/Gemfile
# ./c4s01/r4ia_examples/ticketee/Gemfile
# ./c4s01/r4ia_examples_result/ticketee/components/persistence/Gemfile
# ./c4s01/r4ia_examples_result/ticketee/Gemfile
# ./c2s11/sportsball/deploy/components/app_component/Gemfile
# ./c2s11/sportsball/deploy/Gemfile

GEMFILES=(
  ./c2s01/sportsball/components/app_component/Gemfile
  ./c2s01/sportsball/Gemfile
  ./c2s04/sportsball/components/app_component/Gemfile
  ./c2s04/sportsball/Gemfile
  ./c2s05/sportsball/components/app_component/Gemfile
  ./c2s05/sportsball/Gemfile
  ./c2s06/sportsball/components/app_component/Gemfile
  ./c2s06/sportsball/Gemfile
  ./c2s11/sportsball/components/app_component/Gemfile
  ./c2s11/sportsball/web_container/Gemfile
  ./c3s03/sportsball/components/app_component/Gemfile
  ./c3s03/sportsball/components/predictor/Gemfile
  ./c3s03/sportsball/Gemfile
  ./c3s05/sportsball/components/app_component/Gemfile
  ./c3s05/sportsball/components/games_admin/Gemfile
  ./c3s05/sportsball/components/predictor/Gemfile
  ./c3s05/sportsball/Gemfile
  ./c3s05_finished/sportsball/components/app_component/Gemfile
  ./c3s05_finished/sportsball/components/games_admin/Gemfile
  ./c3s05_finished/sportsball/components/predictor/Gemfile
  ./c3s05_finished/sportsball/components/predictor_ui/Gemfile
  ./c3s05_finished/sportsball/components/teams_admin/Gemfile
  ./c3s05_finished/sportsball/components/welcome_ui/Gemfile
  ./c3s05_finished/sportsball/Gemfile
  ./c3s06/sportsball/components/app_component/Gemfile
  ./c3s06/sportsball/components/games_admin/Gemfile
  ./c3s06/sportsball/components/predictor/Gemfile
  ./c3s06/sportsball/components/predictor_ui/Gemfile
  ./c3s06/sportsball/components/teams/Gemfile
  ./c3s06/sportsball/components/teams_admin/Gemfile
  ./c3s06/sportsball/components/welcome_ui/Gemfile
  ./c3s06/sportsball/Gemfile
  ./c3s06_finished/sportsball/components/app_component/Gemfile
  ./c3s06_finished/sportsball/components/games/Gemfile
  ./c3s06_finished/sportsball/components/games_admin/Gemfile
  ./c3s06_finished/sportsball/components/predictor/Gemfile
  ./c3s06_finished/sportsball/components/predictor_ui/Gemfile
  ./c3s06_finished/sportsball/components/teams/Gemfile
  ./c3s06_finished/sportsball/components/teams_admin/Gemfile
  ./c3s06_finished/sportsball/components/welcome_ui/Gemfile
  ./c3s06_finished/sportsball/Gemfile
  ./c3s07/sportsball/components/games/Gemfile
  ./c3s07/sportsball/components/games_admin/Gemfile
  ./c3s07/sportsball/components/predictor/Gemfile
  ./c3s07/sportsball/components/predictor_ui/Gemfile
  ./c3s07/sportsball/components/teams/Gemfile
  ./c3s07/sportsball/components/teams_admin/Gemfile
  ./c3s07/sportsball/components/web_ui/Gemfile
  ./c3s07/sportsball/components/welcome_ui/Gemfile
  ./c3s07/sportsball/Gemfile
  ./c5s01/sportsball/Gemfile
  ./c5s01/sportsball/components/games/Gemfile
  ./c5s01/sportsball/components/games_admin/Gemfile
  ./c5s01/sportsball/components/predict_game/Gemfile
  ./c5s01/sportsball/components/predictor/Gemfile
  ./c5s01/sportsball/components/predictor_ui/Gemfile
  ./c5s01/sportsball/components/publisher/Gemfile
  ./c5s01/sportsball/components/teams/Gemfile
  ./c5s01/sportsball/components/teams_admin/Gemfile
  ./c5s01/sportsball/components/teams_store_db/Gemfile
  ./c5s01/sportsball/components/teams_store_mem/Gemfile
  ./c5s01/sportsball/components/web_ui/Gemfile
  ./c5s01/sportsball/components/welcome_ui/Gemfile
  ./c5s02/sportsball/Gemfile
  ./c5s02/sportsball/components/games/Gemfile
  ./c5s02/sportsball/components/games_admin/Gemfile
  ./c5s02/sportsball/components/predictor/Gemfile
  ./c5s02/sportsball/components/predictor_ui/Gemfile
  ./c5s02/sportsball/components/teams/Gemfile
  ./c5s02/sportsball/components/teams_admin/Gemfile
  ./c5s02/sportsball/components/web_ui/Gemfile
  ./c5s02/sportsball/components/welcome_ui/Gemfile
)

result=$(expr 0)

cd "$( dirname "${BASH_SOURCE[0]}" )"

for test_script in ${GEMFILES[@]}; do
  echo ""
  echo "#############################################################"
  echo `dirname $test_script`
  echo "#############################################################"
  pushd `dirname $test_script` > /dev/null
  source "$HOME/.rvm/scripts/rvm"
  rvm use 2.3.1
  bundle
  result=$(expr $? + $result)
  echo result
  popd > /dev/null
done

if [ $result -eq 0 ]; then
	echo "BUNDLING SUCCESSFUL"
else
	echo "BUNDLING something went wrong..."
fi

exit $result
