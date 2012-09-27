class SetScraper
require 'open-uri'
require 'nokogiri'

  $rtr = "app/assets/html/rtr.html"
 #http://gatherer.wizards.com/Pages/Search/Default.aspx?sort=cn+&output=spoiler&method=text&set=[%22Return%20to%20Ravnica%22]
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
          if a[:card_type].include? "Basic Land"
            a.merge!({rarity: "Land"})
          else
            a.merge!({ rarity: row.at_xpath('td[2]').text.gsub(set_name, "").strip })
          end
          binding.pry unless Card.create a
          set.cards << Card.last
          a = {}
        end
      end
    end
  end
end
