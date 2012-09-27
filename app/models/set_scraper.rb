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


  def self.split_check(a, b, set)
    if @b
      if @a[:cost] == ''
        @b[:rules] = "#{b[:rules]}\n-----\n#{@a[:name]}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create @b
        set.cards << card
        @b = nil
        @a ={:rules => ''}
      elsif @b[:cost] == ''
        @b = nil
      else
        card = Card.create @b
        set.cards << card
        @b = nil
      end
    end
    if a[:rules].include? "transform" or a[:rules].include? "Transform"
      @b = a
      @a = {}
    end
  end
  def self.flip_check(a, b, set)
    if @b
      if @a[:cost] == ''
        @b[:rules] = "#{b[:rules]}\n-----\n#{@a[:name]}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create @b
        set.cards << card
        @b = nil
        @a ={:rules => ''}
      elsif @b[:cost] == ''
        @b = nil
      else
        card = Card.create @b
        set.cards << card
        @b = nil
      end
    end
    if a[:name].include? "("
      @b = a
      @a = {}
    end
  end


  def self.transform_check(a, b, set)
    if @b #B represents the first half of the untransformed creature. it is set below.
      if @a[:cost] == '' #if the new card has no cost, that means it is probably the second half of a transformed creature
        @b[:rules] = "#{b[:rules]}\n-----\n#{@a[:name]}\n#{@a[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create @b
        set.cards << card
        @b = nil
        @a ={:rules => ''}
      elsif @b[:cost] == '' # Now, Some cards will trigger as having ' transform', but they'll be the other half of flip cards. This checks that and clears it out.
        @b = nil
      else #This is for everything else (read: Moonmist)
        card = Card.create @b
        set.cards << card
        @b = nil
      end
    end
    if a[:rules].include? "transform" or a[:rules].include? "Transform"
      @b = a
      @a = {}
    end
  end

  def self.scrape(set_name, short_name)
    set = Release.create(name: set_name, short_name: short_name)
    set_url = "http://gatherer.wizards.com/Pages/Search/Default.aspx?sort=cn+&output=spoiler&method=text&set=[%22#{set_name.gsub(/\s/, "%20")}%22]"
    doc = Nokogiri::HTML(open(set_url))
    @b = nil
    @a = {}
    doc.search('table > tr').each do |row|
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
         @a.merge!({ name: row.at_xpath('td[2]').text.strip })
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
            SetScraper.transform_check(@a, @b, set)
            Card.create @a
            Card.last.update_attributes(:rarity => "Token") if Card.last.name.include? "token card"
            set.cards << Card.last
          p "#{Card.last.name } saved to #{Card.last.release.name}"
        end #case row
      end #if row.at_xpath
    end #doc.search
  end #self.scrape
end
