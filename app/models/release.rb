class Release < ActiveRecord::Base
  attr_accessible :name, :short_name, :mythicable
  has_many :cards


  def self.name_check
    self.all.each do |release| 
      puts "#{release.name} has no cards!" if release.cards == []
    end
  end
  def dfcs
    self.cards.where("dfc = ?", true)
  end
  def mythics
    self.cards.where("rarity = ?", "Mythic Rare") -self.dfcs
  end

  def rares
    self.cards.where("rarity = ?", "Rare") - self.dfcs
  end

  def uncommons
    self.cards.where("rarity = ?", "Uncommon") - self.dfcs
  end

  def commons
    self.cards.where("rarity = ?", "Common") - self.dfcs
  end

  def basics
    self.cards.where("rarity = ?", "Land")
  end

  def gen_pack
  pack = []
    uncommons = self.uncommons
    commons = self.commons
    if self.mythicable
      case rand(8)
      when 0
        pack << self.mythics.sample
      else
        pack << self.rares.sample
      end
    else
      pack << self.rares.sample
    end
    3.times do
      chosen = uncommons[rand(uncommons.size)]
      pack << chosen
      uncommons = uncommons - [chosen]
    end
    case rand(15)
    when 0
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
    if self.dfcs.size > 0
     pack << self.dfcs.sample
    else
      pack << self.basics.sample if self.basics != []
    end
  pack
  end

  def gen_pool(packs)
    pool = []
    packs.times do
      pool << self.gen_pack
    end
    pool.flatten
  end

end
