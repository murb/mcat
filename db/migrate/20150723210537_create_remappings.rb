class CreateRemappings < ActiveRecord::Migration
  def change
    create_table :remappings do |t|
      t.integer :mapping_id
      t.integer :itembank_id
      t.text :mapping

      t.timestamps null: false
    end
    add_column :items, :remapping_id, :integer
  end
end