class Response < ActiveRecord::Base
  before_save :serialize_item!
  belongs_to :participant

  def serialize_item!
    self.item_serialized = Item.find(self.item_id).serializable_hash
  end
end
