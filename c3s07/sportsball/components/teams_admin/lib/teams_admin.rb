
require "slim-rails"
require "jquery-rails"

require "web_ui"
require "teams"

module TeamsAdmin
  require "teams_admin/engine"

  def self.nav_entry
    {name: "Teams", link: -> {::TeamsAdmin::Engine.routes.url_helpers.teams_path}}
  end
end


