#!/bin/bash

# BUNDLE UPDATE ENHANCER
# Preconditions:
# all components must have a Gemfile
# all components must use RVM and have a .ruby-version and .ruby-gemset

if [ $# -eq 0 ]; then
  echo "💔  No arguments supplied!"
  echo "You must provide the name of the gem you want to update in your main app and all your components."
  exit
fi

# ensure we bundle first
bundle

bundle show $1 > /dev/null
if [ $? -eq 0 ]; then

  echo ">> 🐄  BUE found $1 inside your main application. Updating it and its components now."
  bundle
  bundle update $1

  echo ">> searching $1 inside the components"

  # Iterate over the existing components
  for component_file in $(find . -name *.gemspec); do
    component=`dirname $component_file`
    # Change directory to examined component
    pushd $component > /dev/null

    # Enable rvm
    source "$HOME/.rvm/scripts/rvm"
    rvm use $(cat .ruby-version)@$(cat .ruby-gemset) --create > /dev/null

    # ensure we bundle first
    bundle
    # bundle show is a good citizen and returns unix code 0 when successful.
    bundle show $1 > /dev/null
    if [ $? -eq 0 ]; then
      echo ">> 🐄  BUE found $1 inside $component. Updating it now."
      bundle update $1
    fi

    # Move back directory.
    popd > /dev/null
  done

  echo ">> All done  🏁 "
else
  echo "?? Nothing done, could not find $1"
fi