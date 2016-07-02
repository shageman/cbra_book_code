ActionView::TestCase::TestController.instance_eval do
  helper GamesAdmin::Engine.routes.url_helpers
end
ActionView::TestCase::TestController.class_eval do
  def _routes
    GamesAdmin::Engine.routes
  end
end
