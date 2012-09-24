class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cost
      t.string :pow_tgh
      t.text :card_type
      t.text   :rules
      t.text   :flavor
      t.string :illustrator
      t.string :rarity
      t.string :set_no

      t.references :release

      t.timestamps
    end
  end
end
