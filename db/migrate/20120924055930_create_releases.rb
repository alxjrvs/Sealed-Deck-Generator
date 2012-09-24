class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.references :card
      t.references :booster
      t.timestamps
    end
  end
end
