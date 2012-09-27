class Card < ActiveRecord::Base

  after_create :set_lazy_color, :set_lazy_rarity

  attr_accessible :cost, :flavor, :illustrator, :name, :pow_tgh, :rarity, :rules, :set_no, :card_type, :lazy_color, :lazy_rarity, :photo, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at
  belongs_to :release
  #has_attached_file :scan, {}

  validates :rarity, :presence => true
  def color
    color_id = []
    if self.cost.nil?
      color_id << "Colorless"
    else
      cost.split("").each do |t|
        case t
          when "W"
            color_id.delete("Colorless")
            color_id << "White"
          when "U"
            color_id.delete("Colorless")
            color_id << "Blue"
          when "B"
            color_id.delete("Colorless")
            color_id << "Black"
          when "R"
            color_id.delete("Colorless")
            color_id << "Red"
          when "G"
            color_id.delete("Colorless")
            color_id << "Green"
          when /\d/
            color_id = []
            color_id << "Colorless"
          next
        end
      end
    end
  color_id.uniq
  end

  private

  # Mythic Rare = 1
  # Rare = 2
  # Uncommon = 3
  # Common = 4
  # Basic Land = 5
  # Token = 6

  def set_lazy_rarity

    if self.name.include? "token card"
      self.update_attributes(:lazy_rarity => 6)
    else
      case self.rarity
        when "Mythic Rare"
          self.update_attributes(:lazy_rarity => 1)
        when "Rare"
          self.update_attributes(:lazy_rarity => 2)
        when "Uncommon"
          self.update_attributes(:lazy_rarity => 3)
        when "Common"
          self.update_attributes(:lazy_rarity => 4)
        when "Land"
          self.update_attributes(:lazy_rarity => 5)
      end
    end
  end


  #White = 1
  #Blue = 2
  #Black = 3
  #Red = 4
  #Green = 5
  #Multicolor = 6
  #Artifact = 7
  #Land = 8


  def set_lazy_color
    if self.card_type.include? "Land" or self.name.include? "token card"
      #binding.pry
      self.update_attributes(:lazy_color => 8)
    elsif self.color.size > 1
      self.update_attributes(:lazy_color => 6)
    else
      case self.color[0]
        when "White"
          self.update_attributes(:lazy_color => 1)
        when "Blue"
          self.update_attributes(:lazy_color => 2)
        when "Black"
          self.update_attributes(:lazy_color => 3)
        when "Red"
          self.update_attributes(:lazy_color => 4)
        when "Green"
          self.update_attributes(:lazy_color => 5)
        when "Colorless"
          self.update_attributes(:lazy_color => 7)
      end
    end
  end
end
