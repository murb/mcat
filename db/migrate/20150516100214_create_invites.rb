class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :invite_hash
      t.text :comments
      t.integer :examinator_id
      t.string :code
      t.timestamps null: false
    end

  end
end