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

  def short_hash
    to_param[0..7]
  end

  def responses_as_text
    rv = ""
    responses.each do |r|
      rv << "[#{r.itembank_id},#{r.item_id}]=#{r.value}\n"
    end
    rv
  end
  def outcome_text
    "Lichamelijk functioneren: #{evaluate[:estimate][0].round(1)} (#{evaluate[:se][0].round(1)})\nVermoeidheid: #{evaluate[:estimate][1].round(1)} (#{evaluate[:se][1].round(1)})\nVermogen om aandeel te hebben in sociale rollen en activiteiten: #{evaluate[:estimate][2].round(1)} (#{evaluate[:se][2].round(1)})\nImpact van COPD-gerelateerde klachten: #{evaluate[:estimate][3].round(1) }(#{evaluate[:se][3].round(1)})"
  end

  def init_response response_params
    responses.where(item_id:response_params[:item_id]).destroy_all
    response = Response.new(response_params)
    response.participant = self
    response
  end

  def evaluate
    @evaluate ||= itembank.evaluate(responses_to_stat_hash,itembank.items.alphas.first.count.times.collect{1})
  end

  def result

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
