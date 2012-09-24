class Release < ActiveRecord::Base
  attr_accessible :name
  has_many :cards

  def mythics
    self.cards.where("rarity = ?", "Mythic Rare")
  end

  def rares
    self.cards.where("rarity = ?", "Rare")
  end

  def uncommons
    self.cards.where("rarity = ?", "Uncommon")
  end

  def commons
    self.cards.where("rarity = ?", "Common")
  end

  def basics
    self.cards.where("rarity = ?", "Basic Land")
  end

  def gen_pack
  pack = []
    uncommons = self.uncommons
    commons = self.commons
    3.times do
      chosen = uncommons[rand(uncommons.size)]
      pack << chosen
      uncommons = uncommons - [chosen]
    end
    case rand(8)
    when 0
      p "mythic"
      pack << self.mythics.sample
    else
      pack << self.rares.sample
    end
    case rand(15)
    when 0
      puts "foil"
      pack << self.cards.sample
      9.times do
        chosen = commons[rand(commons.size)]
        pack << chosen
        commons = commons - [chosen]
      end
    else
      10.times do
        chosen = commons[rand(commons.size)]
        pack << chosen
        commons = commons - [chosen]
      end
    end
    pack << self.basics.sample
  pack
  end

  def gen_pool(packs)
    pool = []
    packs.times do
      pool << self.gen_pack
    end
    pool
  end
end
