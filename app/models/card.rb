class Card < ActiveRecord::Base
  attr_accessible :cost, :flavor, :illustrator, :name, :pow_tgh, :rarity, :rules, :set_no, :card_type
  belongs_to :release
  #def lazy_sort
    #case self.rarity
    #when "Mythic Rare"
      #1
    #when "Rare"
      #2
    #when "Uncommon"
      #3
    #when "Common"
      #4
    #end
  #end

  def color
    color_id = []

    if self.cost.nil?
      color_id << "None"
    else
      cost.split("").each do |t|
        case t
          when "W"
            color_id << "White"
          when "U"
            color_id << "Blue"
          when "B"
            color_id << "Black"
          when "R"
            color_id << "Red"
          when "G"
            color_id << "Green"
          when /\d/
            color_id = []
            color_id << "None"
          next
        end
      end
    end
  color_id.uniq
  end
end
