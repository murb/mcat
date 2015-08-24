class Participant < ActiveRecord::Base
  before_create :hash_participant!
  has_many :responses
  validates :participant_hash, uniqueness: true
  belongs_to :itembank
  belongs_to :invite, foreign_key: :invite_hash, primary_key: :invite_hash
  has_one :examinator, through: :invite

  # Returns a hash representing the participant('s session)
  #
  # @return [String] a hashed string
  def hash_participant!
    self.participant_hash = Digest::SHA2.new(256).update("#{self.serializable_hash}+#{Time.now}+jibrrrji!@#sh.+#{session}").to_s
  end

  # Parameterized ID
  #
  # @return [String] the participant_hash
  def to_param
    "#{participant_hash}"
  end

  # Short ID
  #
  # @return [String] the participant_hash shortened to 8 characters
  def short_hash
    to_param[0..7]
  end

  # Responses as text returns the participant's responses as text
  #
  # @return [String] with the responses in ASCII text
  def responses_as_text
    rv = ""
    responses.each do |r|
      rv << "[#{r.itembank_id},#{r.item_id}]=#{r.value}\n"
    end
    rv
  end


  # Outcome text returns the participant's outcome as text
  #
  # @return [String] with the outcome in ASCII text
  def outcome_text
    "Lichamelijk functioneren: #{evaluate[:estimate][0].round(1)} (#{evaluate[:se][0].round(1)})\nVermoeidheid: #{evaluate[:estimate][1].round(1)} (#{evaluate[:se][1].round(1)})\nVermogen om aandeel te hebben in sociale rollen en activiteiten: #{evaluate[:estimate][2].round(1)} (#{evaluate[:se][2].round(1)})\nImpact van COPD-gerelateerde klachten: #{evaluate[:estimate][3].round(1) }(#{evaluate[:se][3].round(1)})"
  end

  # Init response initializes a new response for the current participant
  #
  # @param response_params sets the new response's parameters
  # @return [Response] as an object

  def init_response response_params
    responses.where(item_id:response_params[:item_id]).destroy_all
    response = Response.new(response_params)
    response.participant = self
    response
  end

  # Evaluates all responses given and returns the outcomes, see Itembank#evaluate
  #
  # @return [Hash] see {Itembank#evaluate}
  def evaluate
    @evaluate ||= itembank.evaluate(responses_to_stat_hash,itembank.items.alphas.first.count.times.collect{1})
  end

  # Translate responses to an hash to be used in the {#evaluate} method
  #
  # @return [Hash] see {Response#evaluate}
  def responses_to_stat_hash
    responses.to_stat_hash(self)
  end
end
