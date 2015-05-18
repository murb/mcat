class Invite < ActiveRecord::Base
  before_create :create_invite_hash!
  has_many :participants, foreign_key: :invite_hash, primary_key: :invite_hash
  belongs_to :examinator

  scope :by_examinator, ->(a) { where(examinator_id: a.id)}

  def create_invite_hash!
    self.invite_hash = Digest::SHA2.new(256).update("#{self.serializable_hash}+#{Time.now}+jibffffrrrji!@#sh").to_s[2..12]
  end

end
