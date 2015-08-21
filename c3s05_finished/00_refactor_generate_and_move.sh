#!/bin/sh

cd sportsball

RnAll() {
    for f in "$1"/* ; do
        [ -d "$f" ] || continue
        ( RnAll "$f" "$2" "$3" )
        [ "`basename $f`" \== "$2" ] && mv "$f" "`dirname $f`/$3"
    done
}

RenameComponent() {
   RnAll "$1" "$2" "$3"

   mv components/$3/$2.gemspec components/$3/$3.gemspec
   mv components/$3/lib/$2.rb components/$3/lib/$3.rb

   grep -rl "$4" $1 | \
      xargs sed -i '' 's/'$4'/'$5'/g'
   grep -rl "$2" $1 | \
      xargs sed -i '' 's;'$2';'$3';g'
}

RenameComponent . games_ui games_admin GamesUi GamesAdmin
RenameComponent . teams_ui teams_admin TeamsUi TeamsAdmin


