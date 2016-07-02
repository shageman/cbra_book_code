#!/usr/bin/env bash

mv components/app/ components/app_component

mv components/app_component/app/assets/images/app             components/app_component/app/assets/images/app_component
mv components/app_component/app/assets/javascripts/app components/app_component/app/assets/javascripts/app_component
mv components/app_component/app/assets/stylesheets/app components/app_component/app/assets/stylesheets/app_component

mv components/app_component/app/controllers/app components/app_component/app/controllers/app_component
mv components/app_component/app/helpers/app components/app_component/app/helpers/app_component
mv components/app_component/app/models/app components/app_component/app/models/app_component

mv components/app_component/app/views/app components/app_component/app/views/app_component
mv components/app_component/app/views/layouts/app components/app_component/app/views/layouts/app_component

mv components/app_component/lib/app.rb components/app_component/lib/app_component.rb
mv components/app_component/lib/app components/app_component/lib/app_component
mv components/app_component/lib/tasks/app_tasks.rake components/app_component/lib/tasks/app_component_tasks.rake

mv components/app_component/spec/controllers/app components/app_component/spec/controllers/app_component
mv components/app_component/spec/helpers/app components/app_component/spec/helpers/app_component
mv components/app_component/spec/models/app components/app_component/spec/models/app_component
mv components/app_component/spec/routing/app components/app_component/spec/routing/app_component
mv components/app_component/spec/views/app components/app_component/spec/views/app_component

mv components/app_component/app_component.gemspec     components/app_component/app_component.gemspec