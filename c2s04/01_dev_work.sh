#!/bin/sh

rails g scaffold team name:string

rails g scaffold game date:datetime location:string \
                      first_team_id:integer second_team_id:integer \
                      winning_team:integer \
                      first_team_score:integer second_team_score:integer

#cd ../..
#rake app:install:migrations
#
#cd ..
#tree sportsball/components/app/db/migrate > engine_migrations.tree
#tree sportsball/db/migrate > app_migrations.tree

#fix ./add migration loading to engine file
sed -i .bac '5a\
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s+File::SEPARATOR
        app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
      end
    end
' Gemfile

