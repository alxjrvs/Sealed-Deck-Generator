class Card < ActiveRecord::Base
  attr_accessible :cost, :flavor, :illustrator, :name, :pow_tgh, :rarity, :rules, :set_no, :card_type
end
