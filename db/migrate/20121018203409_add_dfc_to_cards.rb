class AddDfcToCards < ActiveRecord::Migration
  def change
    add_column :cards, :dfc, :boolean
  end
end
