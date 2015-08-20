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

  def item
    begin
      return Item.find(self.item_id)
    rescue
    end
  end

  def question
    "#{item.variable_name}: #{item.item_stem} #{item.reverse_scale ? '(Reversed)' : ''}" if item
  end

  def itembank_id
    itembank.id if itembank
  end

  def text_value
    choice_option_set.text_for(value) if item
  end

  def set_stat_value!
    self.stat_value = item.reverse_scale? ? (-1 * (value)) + 4 : (value)
    self.stat_value = remapping.remap(self.stat_value)
  end

  def serialize_item!
    self.item_serialized = item.serializable_hash(include: :choice_option_set)
  end

  class << self
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
