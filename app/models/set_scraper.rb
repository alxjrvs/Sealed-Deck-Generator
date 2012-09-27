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

  def self.scrape(set_name, short_name)
    set = Release.create(name: set_name, short_name: short_name)
    set_url = "http://gatherer.wizards.com/Pages/Search/Default.aspx?sort=cn+&output=spoiler&method=text&set=[%22#{set_name.gsub(/\s/, "%20")}%22]"
    doc = Nokogiri::HTML(open(set_url))
    a = {}
    #binding.pry
    doc.search('table > tr').each do |row|
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
         a.merge!({ name: row.at_xpath('td[2]').text.strip })
        when "Cost:"
          a.merge!({ cost: row.at_xpath('td[2]').text.strip.upcase })
        when "Type:"
          a.merge!({ card_type: row.at_xpath('td[2]').text.strip })
        when "Rules Text:"
          a.merge!({ rules: row.at_xpath('td[2]').text.strip.gsub(/\r/," ")  })
        when "Flavor Text:"
          a.merge!({ flavor: row.at_xpath('td[2]').text.strip })
        when "Illus."
          a.merge!({ illustrator: row.at_xpath('td[2]').text.strip })
        when "Pow/Tgh:"
          a.merge!({ pow_tgh: row.at_xpath('td[2]').text.strip })
        when "Set/Rarity:"
          a.merge!({ rarity: SetScraper.rarity_sort(set_name, row.at_xpath('td[2]').text) })
          Card.create a
          set.cards << Card.last
          p "#{Card.last.name } saved to #{Card.last.release.name}"
          a = {}
        end #case row
      end #if row.at_xpath
    end #doc.search
  end #self.scrape

end
