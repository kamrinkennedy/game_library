class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :players
      t.text :description
      t.references :platform
      t.references :user
    end
  end
end
