class Release < ActiveRecord::Base
  belongs_to: card
  belongs_to: booster
end
