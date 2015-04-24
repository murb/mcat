class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :session
      t.string :invite_hash
      t.string :participant_hash
      t.integer :age
      t.string :gender

      t.timestamps null: false
    end
  end
end
