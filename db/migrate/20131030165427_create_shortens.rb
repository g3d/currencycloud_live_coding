class CreateShortens < ActiveRecord::Migration
  def change
    create_table :shortens do |t|
      t.string :slug
      t.string :url
      t.integer :visits, default: 0

      t.timestamps
    end
    add_index :shortens, :slug
  end
end
