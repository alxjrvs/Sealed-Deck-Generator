class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cost
      t.string :pow_tgh
      t.string :card_type
      t.string :rules
      t.string :flavor
      t.string :illustrator
      t.string :rarity
      t.string :set_no

      t.references :release

      t.timestamps
    end
  end
end
