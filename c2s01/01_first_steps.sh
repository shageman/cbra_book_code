#!/bin/sh




#cd ~/workspace/cbra
rails new sportsball

cd sportsball
rm -r app

mkdir components

rails plugin new components/app_component --full --mountable

cd components/app_component
rails g controller welcome index

cd ../..
bundle
rails s


#fix ./components/app_component/config/routes.rb
echo 'AppComponent::Engine.routes.draw do
  root to: "welcome#index"
end' > components/app/config/routes.rb

#fix ./Gemfile
sed -i .bac '2a\
gem "app_component", path: "components/app_component"
' Gemfile

##fix ./config/routes.rb
echo 'Rails.application.routes.draw do
  mount AppComponent::Engine, at: "/"
end' > config/routes.rb

