class AddShortnameToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :short_name, :string
  end
end
