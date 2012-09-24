class Card < ActiveRecord::Base
  attr_accessible :cost, :flavor, :illustrator, :name, :pow_tgh, :rarity, :rules, :set_no, :card_type
  belongs_to :release

  def self.mythics
    Card.where("rarity = ?", "Mythic Rare")
  end

  def self.rares
    Card.where("rarity = ?", "Rare")
  end

  def self.uncommons
    Card.where("rarity = ?", "Uncommon")
  end

  def self.commons
    Card.where("rarity = ?", "Common")
  end

  def self.basics
    Card.where("rarity = ?", "Basic Land")
  end

  def self.gen_pack
  pack = []
    3.times do
      pack << Card.uncommons.sample
    end
  pack
  end
end
