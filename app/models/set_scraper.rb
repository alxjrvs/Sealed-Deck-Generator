class SetScraper
require 'open-uri'
require 'nokogiri'

  $rtr = "app/assets/html/rtr.html"

  def self.scrape(set_url, set_name)
    set = Release.create(name: set_name)
    doc = Nokogiri::HTML(open(set_url))
    a = {}
    doc.search('table > tr').each do |row|
      if row.search('td').size == 1 and row.search('br').size > 0 and a.size > 3
        card = Card.create a
        set.cards << card
        a = {}
        #misses the last card.
        #SetScraper.scrape("http://mtgsalvation.com/printable-return-to-ravnica-spoiler.html")
      end
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
          h = { name: row.at_xpath('td[2]').text.strip }
        when "Cost:"
          h = { cost: row.at_xpath('td[2]').text.strip.upcase }
        when "Type:"
          h = { card_type: row.at_xpath('td[2]').text.strip }
        when "Rules Text:"
          h = { rules: row.at_xpath('td[2]').text.strip.gsub(/\r/," ")  }
        when "Flavor Text:"
          h = { flavor: row.at_xpath('td[2]').text.strip }
        when "Illus."
          h = { illustrator: row.at_xpath('td[2]').text.strip }
        when "Pow/Tgh:"
          h = { pow_tgh: row.at_xpath('td[2]').text.strip }
        when "Rarity:"
          h = { rarity: row.at_xpath('td[2]').text.strip }
        when "Set Number:"
          h = { set_no: row.at_xpath('td[2]').text.strip }
        end
        a = a.merge(h)
      end
    end
  end
end
