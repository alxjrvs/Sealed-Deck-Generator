class Release < ActiveRecord::Base
  attr_accessible :name
  has_many :cards
end
