ActionView::TestCase::TestController.instance_eval do
  helper TeamsAdmin::Engine.routes.url_helpers
end
ActionView::TestCase::TestController.class_eval do
  def _routes
    TeamsAdmin::Engine.routes
  end
end
