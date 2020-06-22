class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :num_of_players
      t.references :user
    end
  end
end
