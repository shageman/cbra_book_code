#!/bin/bash

exit_code=0

echo "*** Running app component engine specs FOR RAILS 5"
RAILS_5_UPDATE=true bundle exec rake db:create db:migrate
RAILS_5_UPDATE=true RAILS_ENV=test bundle exec rake db:create db:migrate
RAILS_5_UPDATE=true bundle exec rspec spec
exit_code+=$?

exit $exit_code
