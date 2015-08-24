class Response < ActiveRecord::Base
  validates :value, presence: true
  before_save :serialize_item!
  before_save :set_stat_value!
  belongs_to :participant
  belongs_to :item
  has_one :choice_option_set, through: :item
  has_one :itembank, through: :item
  has_one :remapping, through: :item


  scope :filter_by_participant_hashes, ->(a) { joins(:participant).where(participants:{participant_hash:a})}

  # Get the item belonging to the response, failing quietly.
  #
  # @return [Item] belonging to the response
  def item
    begin
      return Item.find(self.item_id)
    rescue
    end
  end

  # Question
  #
  # @return [String] as a text representation of the question
  def question
    "#{item.variable_name}: #{item.item_stem} #{item.reverse_scale ? '(Reversed)' : ''}" if item
  end

  # Itembank_id
  #
  # @return [Integer, Nil] Returns the internal ID of the itembank
  def itembank_id
    itembank.id if itembank
  end

  # Text value
  #
  # @return [String] Returns the string that belongs to the value given
  def text_value
    choice_option_set.text_for(value) if item
  end

  # Set stat value
  #
  # @return [Integer] the value internally used to do the statistical calculations
  def set_stat_value!
    self.stat_value = item.reverse_scale? ? (-1 * (value)) + 4 : (value)
    self.stat_value = remapping.remap(self.stat_value)
  end

  # Serialize item
  # The item itself is serialized, to investigate changes in questions asked.
  #
  # @return [String] serialized version of the item
  def serialize_item!
    self.item_serialized = item.serializable_hash(include: :choice_option_set)
  end

  class << self
    # To stat hash
    #
    # @return [Hash] A collection of responses to a hash that can be used in the MultiCat
    def to_stat_hash(participant)
      items = participant.itembank.items
      rv = {}
      self.all.each do |response|
        rv[items.index(response.item_id)+1] = response.stat_value if (response.item_id and items.index(response.item_id))
      end
      return rv
    end
  end
end
