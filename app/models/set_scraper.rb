class SetScraper
require 'open-uri'
require 'nokogiri'

  def self.scrape(set_url)
    doc = Nokogiri::HTML(open(set_url))
    final_list = []
    a = {}
    doc.search('table > tr').each do |row|
      if row.at_xpath('td[2]')
        h = { row.at_xpath('td[1]').text.strip => row.at_xpath('td[2]').text.strip }
        a = a.merge(h)
        if row.at_xpath('td[1]').text.strip == "Set Number:"
          final_list << a
          a = {}
        end
      end
    end
    final_list
  end
end
