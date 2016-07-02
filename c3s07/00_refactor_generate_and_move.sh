#!/bin/sh

cd sportsball

RnAll() { for f in "$1"/* ; do [ -d "$f" ] || continue ; ( RnAll "$f" "$2" "$3" ) ; [ "`basename $f`" \== "$2" ] && mv "$f" "`dirname $f`/$3" ; done }
RnAll . app_component web_ui

grep -rl --exclude-dir=migrate --exclude-dir=sprockets "AppComponent" . | xargs sed -i '' 's/AppComponent/WebUi/g'

grep -rl --exclude-dir=migrate --exclude-dir=sprockets --exclude=*.log "app_component" . | xargs sed -i '' 's;app_component;web_ui;g'
