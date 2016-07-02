ActionView::TestCase::TestController.instance_eval do
  helper AppComponent::Engine.routes.url_helpers
end
ActionView::TestCase::TestController.class_eval do
  def _routes
    AppComponent::Engine.routes
  end
end
