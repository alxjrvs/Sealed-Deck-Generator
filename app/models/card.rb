class Card < ActiveRecord::Base
  attr_accessible :cost, :flavor, :illustrator, :name, :pow_tgh, :rarity, :rules, :set_no, :card_type
  has_many :sets
  has_many :boosters, :through => :sets
end
