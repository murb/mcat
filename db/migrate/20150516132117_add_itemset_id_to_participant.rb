class AddItemsetIdToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :itembank_id, :integer, default: Itembank.first.id
  end
end