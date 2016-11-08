class AddPublishedToWikis < ActiveRecord::Migration
  def change
    add_column :wikis, :published, :boolean
  end
end
