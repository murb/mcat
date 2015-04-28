class Response < ActiveRecord::Base
  before_save :serialize_item!
  before_save :set_stat_value!
  belongs_to :participant
  belongs_to :item

  def item
    Item.find(self.item_id)
  end

  def set_stat_value!
    self.stat_value = item.reverse_scale? ? (-1 * value) + 6 : value
  end

  def serialize_item!
    self.item_serialized = item.serializable_hash(include: :choice_option_set)
  end
end
