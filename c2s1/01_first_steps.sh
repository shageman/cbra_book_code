#!/bin/sh




#cd ~/workspace/cbra
rails new sportsball

cd sportsball
rm -r app

mkdir components

rails plugin new components/app --full --mountable

cd components/app
rails g controller welcome index

cd ../..
bundle
rails s


#fix ./components/app/config/routes.rb
echo 'App::Engine.routes.draw do
  root to: "welcome#index"
end' > components/app/config/routes.rb

#fix ./Gemfile
sed -i .bac '2a\
gem "app", path: "components/app"
' Gemfile

##fix ./config/routes.rb
echo 'Rails.application.routes.draw do
  mount App::Engine, at: "/"
end' > config/routes.rb

