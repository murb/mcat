class Participant < ActiveRecord::Base
  before_create :hash_participant!
  has_many :responses
  validates :participant_hash, uniqueness: true
  belongs_to :itembank
  belongs_to :invite, foreign_key: :invite_hash, primary_key: :invite_hash
  has_one :examinator, through: :invite

  def hash_participant!
    self.participant_hash = Digest::SHA2.new(256).update("#{self.serializable_hash}+#{Time.now}+jibrrrji!@#sh.+#{session}").to_s
  end

  def to_param
    "#{participant_hash}"
  end

  def evaluate
    @evaluate ||= itembank.evaluate(responses_to_stat_hash,[1,1,1])
  end

  def responses_to_stat_hash
    responses.to_stat_hash(self)
  end

  # class << self
  #   def from_param(param)
  #     find_by_participant_hash!(param)
  #   end
  # end
end
