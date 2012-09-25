class AddLazyRarityAndLazyColorToCard < ActiveRecord::Migration
  def change
    add_column :cards, :lazy_color, :integer
    add_column :cards, :lazy_rarity, :integer
  end
end
