# create_table "remappings", force: :cascade do |t|
#   t.integer  "mapping_id"
#   t.integer  "itembank_id"
#   t.text     "mapping"
#   t.datetime "created_at",  null: false
#   t.datetime "updated_at",  null: false
# end
class Remapping < ActiveRecord::Base
  belongs_to :itembank
  has_many :items
  store :mapping

  validates :mapping, presence: true
  validates :mapping_id, presence: true

  def mapping= unparsed_txt
    mapping_hash = {}
    if unparsed_txt.class == Hash
      mapping_hash = unparsed_txt
    else
      unparsed_txt.strip.split("\n").each do |option|
        options_split = option.split("=")
        value = options_split.first.strip.to_i
        desc = options_split.last.strip
        mapping_hash[value]=desc
      end
    end
    write_attribute(:mapping, mapping_hash)
  end
end
