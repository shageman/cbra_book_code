

require "slim-rails"
require "jquery-rails"

require "web_ui"
require "teams_store"
require "games"

module GamesAdmin
  require "games_admin/engine"

  def self.nav_entry
    {name: "Games", link: -> {::GamesAdmin::Engine.routes.url_helpers.games_path}}
  end
end


