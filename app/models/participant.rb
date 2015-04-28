class Participant < ActiveRecord::Base
  before_create :hash_participant!
  has_many :responses

  def hash_participant!
    self.participant_hash = Digest::SHA2.new(256).update("#{self.serializable_hash}+#{Time.now}+jibrrrji!@#sh.+#{session}").to_s
  end
end
