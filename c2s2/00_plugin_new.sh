#!/bin/sh

rails plugin >> rails_plugin_new.txt




rails plugin new plain_plugin
rails plugin new full_engine --full
rails plugin new mountable_engine --mountable
rails plugin new full_mountable_engine --full --mountable
bundle gem bundle_gem

tree plain_plugin -d > plain_plugin.tree
tree full_engine -d > full_engine.tree
tree mountable_engine -d > mountable_engine.tree
tree full_mountable_engine -d > full_mountable_engine.tree
tree bundle_gem -d > bundle_gem.tree



rails plugin new plain_plugin_rspec --dummy-path=spec/dummy --skip-test-unit
cd plain_plugin_rspec
#add rspec to gemfile
sed -i .bac '2a\
gem "rspec"
' Gemfile
bundle

cd ..
cd full_engine
rails g model user name:string

cd ..
cd mountable_engine
rails g scaffold user name:string

rake app:routes >> ../rake_app_routes.txt

rake -T >> ../rake_t.txt