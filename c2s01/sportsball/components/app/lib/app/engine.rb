module App
  class Engine < ::Rails::Engine
    isolate_namespace App
  end
end
