class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name

      t.timestamps
    end
  end
end
