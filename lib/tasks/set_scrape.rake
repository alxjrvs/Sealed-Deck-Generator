task :scrape => :environment do
  sets_list = [
  ["Return to Ravnica", "RTR"],
  ["Magic 2013", "M13"],
  ["Avacyn Restored", "AVR"],
  ["Dark Ascension", "DKA"],
  ["Innistrad", "ISD"],
  ["Magic 2012", "M12"],
  ["New Phyrexia", "NPH"],
  ["Mirrodin Besieged", "MBS"],
  ["Scars of Mirrodin", "SOM"],
  ["Magic 2011", "M11"],
  ["Rise of the Eldrazi","ROE"],
  ["Worldwake","WWK"],
  ["Zendikar","ZEN"],
  ["Magic 2010", "M10"],
  ["Alara Reborn","ARB"],
  ["Conflux","CON"],
  ["Shards of Alara","ALA"],


  ["Unhinged", "UNH"],
  ["Unglued", "UGL"]
  ]
  sets_list.each do |set|
    SetScraper.scrape(set[0], set[1])
  end

end
