class Invite < ActiveRecord::Base
  before_create :create_invite_hash!
  has_many :participants, foreign_key: :invite_hash, primary_key: :invite_hash
  belongs_to :examinator

  scope :by_examinator, ->(a) { where(examinator_id: a.id)}

  # Create invite hash, a hash that can be used to invite participants
  #
  # == Return:
  #   String that is unique
  def create_invite_hash!
    self.invite_hash = Digest::SHA2.new(256).update("#{self.serializable_hash}+#{Time.now}+jibffffrrrji!@#sh").to_s[2..12]
  end

  # Returns the examinator email address, if known
  #
  # @return [String] with email address or Nil
  def examinator_email
    examinator ? examinator.email : nil
  end

  class << self
    # Returns the results of all invites.
    #
    # @return [Workbook::Book] A {http://github.com/murb/workbook workbook} that can be saved to e.g. XLSX, CSV or XLS
    def to_workbook
      w = Workbook::Book.new([["Examinator","Invite Hash","Codering","Opmerking","Deelnemer","Antwoorden","Estimates","URL"]])
      self.all.each do |invite|
        invite.participants.each do | participant |
          w.sheet.table << [ invite.examinator_email, invite.invite_hash, invite.code, invite.comments, participant.participant_hash, participant.responses_as_text, participant.outcome_text ]
        end
      end
      w
    end
  end

end
