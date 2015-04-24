class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :participant_id
      t.integer :item_id
      t.text :item_serialized
      t.integer :value

      t.timestamps null: false
    end
  end
end
