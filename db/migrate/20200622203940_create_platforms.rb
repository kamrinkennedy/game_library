class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :name
      t.string :online
      t.references :user
    end
  end
end
