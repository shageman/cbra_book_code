module AppComponent
  class Team < ActiveRecord::Base
    validates :name, presence: true
  end
end
