class Card < ActiveRecord::model

attr_accessor :name, :card_type, :rarity
has_many :colors, :through =>  :card_colors
has_many :card_colors
belongs_to :set


end

