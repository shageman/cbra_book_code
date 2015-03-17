Rails.application.routes.draw do

  mount MountableEngine::Engine => "/mountable_engine"
end
