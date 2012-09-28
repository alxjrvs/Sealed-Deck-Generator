class AddMythicableToRelease < ActiveRecord::Migration
  def change
    add_column :releases, :mythicable, :binary
  end
end
