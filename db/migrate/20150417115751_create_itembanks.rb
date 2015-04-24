class CreateItembanks < ActiveRecord::Migration
  def change
    create_table :itembanks do |t|
      t.string :name
      t.string :source

      t.timestamps null: false
    end
  end
end
