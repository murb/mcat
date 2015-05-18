class IndexParticipantHash < ActiveRecord::Migration
  def change
    Participant.where(:participant_hash=>nil).destroy_all
    add_index :participants, :participant_hash, unique: true

  end
end