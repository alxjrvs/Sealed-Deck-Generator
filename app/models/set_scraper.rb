class SetScraper
require 'open-uri'
require 'nokogiri'

  def self.rarity_sort(set_name, string)
    rarity = ''
    string.strip.split(",").each do |x|
      rarity  =x.gsub(set_name, '').strip if x.include? set_name
    end
  rarity
  end #rarity_sort


  def self.split_merge(hash)
    "#{/(\w*)/.match(hash[:name]).to_s}\n#{hash[:cost]}\n#{hash[:card_type]}\n#{hash[:rules]}\n#{hash[:pow_tgh]} "
  end

  def self.split_check # For these, we don't care what comes first. Load it into @b, stich it together, godspeed.
    if @b
      @b.merge!({:name => /\w* \/\/ \w*/.match(@b[:name]).to_s,
      :cost => "#{@b[:cost]} // #{@a[:cost]}",
      :card_type => "#{@b[:card_type]} //#{@a[:card_type]}",
      :rules => "#{split_merge(@b)}\n-----\n#{split_merge(@a)}"}
     )
      card = Card.create @b
      @set.cards << card
      @b = nil
      @a ={:name => ''}
    end
    if /\w* \/\/ \w*/.match(@a[:name])
      @b = @a
      @a = {}
    end
  end
  def self.flip_check #In this case, it's a little easier to sort - the names of the cards appear on each other. However, the Order is  potentially different.
    if @b #This is the secondary '@b' Loop the flipped card came first.
      if @a[:rules].include? "#flip {@a[:name]}" or @a[:rules].include? "flip it"
        @b[:rules] = "#{@b[:rules]}\n-----\n#{@a[:name]}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create @b
        @set.cards << card
        @b = nil
        @a ={:name => '', :rules => ''}
      end
    end
    if @a[:name].include? "("
      if @a[:name].include? Card.last.name #this if group handles it if the Flip card came second.
        Card.last.update_attributes(:rules => "#{Card.last.rules}\n-----\n#{@a[:name].gsub(Card.last.name, '')}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}")
        @a = {}
      else
        @b = @a
        @a = {}
      end
    end
  end


  def self.transform_check
    if @b #B represents the first half of the untransformed creature. it is set below.
      if @a[:cost] == '' #if the new card has no cost, that means it is probably the second half of a transformed creature
        @b[:rules] = "#{@b[:rules]}\n-----\n#{@a[:name]}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create @b
        @set.cards << card
        @b = nil
        @a ={:rules => '', :name => ''}
      elsif @b[:cost] == '' # Now, Some cards will trigger as having ' transform', but they'll be the other half of flip cards. This checks that and clears it out.
        @b = nil
      else #This is for everything else (read: Moonmist)
        card = Card.create @b
        @set.cards << card
        @b = nil
      end
    end
    if @a[:rules].include? "transform" or @a[:rules].include? "Transform"
      @b = @a
      @a = {}
    end
  end

  def self.scrape(set_name, short_name, mythics = nil)
    @set = Release.create(name: set_name, short_name: short_name, mythicable: mythics)
    set_url = "http://gatherer.wizards.com/Pages/Search/Default.aspx?sort=cn+&output=spoiler&method=text&set=[%22#{set_name.gsub(/\s/, "%20")}%22]"
    doc = Nokogiri::HTML(open(set_url))
    @b = nil
    @a = {}
    @split = false
    doc.search('table > tr').each do |row|
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
         @a.merge!({ name: row.at_xpath('td[2]').text.strip })
          @split = true if @a[:name].include? '//'
        when "Cost:"
         @a.merge!({ cost: row.at_xpath('td[2]').text.strip.upcase })
        when "Type:"
          @a.merge!({ card_type: row.at_xpath('td[2]').text.strip })
        when "Rules Text:"
          @a.merge!({ rules: row.at_xpath('td[2]').text.strip.gsub(/\r/," ")  })
        when "Flavor Text:"
          @a.merge!({ flavor: row.at_xpath('td[2]').text.strip })
        when "Illus."
          @a.merge!({ illustrator: row.at_xpath('td[2]').text.strip })
        when "Pow/Tgh:"
          @a.merge!({ pow_tgh: row.at_xpath('td[2]').text.strip })
        when "Set/Rarity:"
            @a.merge!({ rarity: SetScraper.rarity_sort(set_name, row.at_xpath('td[2]').text) })
            SetScraper.flip_check  if set_name.include? "Kamigawa"
            SetScraper.split_check if @split
            SetScraper.transform_check if short_name == "ISD" or short_name == "DKA"
            Card.create @a
            @a = {}
            Card.last.update_attributes(:rarity => "Token") if Card.last.name.include? "token card"
            @set.cards << Card.last
          p "#{Card.last.name } saved to #{Card.last.release.name}"
        end #case row
      end #if row.at_xpath
    end #doc.search
  end #self.scrape
end
