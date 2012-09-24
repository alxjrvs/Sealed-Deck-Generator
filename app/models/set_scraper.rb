class SetScraper
require 'open-uri'
require 'nokogiri'

  def self.scrape(set_url)
    doc = Nokogiri::HTML(open(set_url))
    a = {}
    doc.search('table > tr').each do |row|
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
          h = { name: row.at_xpath('td[2]').text.strip }
        when "Cost:"
          h = { cost: row.at_xpath('td[2]').text.strip }
        when "Type:"
          h = { card_type: row.at_xpath('td[2]').text.strip }
        when "Rules Text:"
          h = { rules: row.at_xpath('td[2]').text.strip }
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
        if row.search('b').size > 0 and a.size > 3 
          Card.create a 
          a = {}
          #misses the last card.
          #SetScraper.scrape("http://mtgsalvation.com/printable-return-to-ravnica-spoiler.html")
        end
      end
    end
  end
end
