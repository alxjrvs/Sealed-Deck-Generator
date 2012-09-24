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
      self.cost.split("").each do |t|
        case t
          when "w", "W"
          color_id << "White"
          when "u", "U"
          color_id << "Blue"
          when "b", "B"
          color_id << "Black"
          when "r", "R"
          color_id << "Red"
          when "g", "G"
          color_id << "Green"
          else
          color_id << "None"
          next
        end
      end
    end
  color_id.uniq
  end
end
