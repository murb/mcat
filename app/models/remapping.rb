class Remapping < ActiveRecord::Base
  belongs_to :itembank
  has_many :items
  store :mapping

  validates :mapping, presence: true
  validates :mapping_id, presence: true

  # Remaps a not unmapped value
  #
  # @param unmapped_value [Integer] value that should be mapped
  # @return [Integer] new value
  def remap unmapped_value
    new_value = mapping[unmapped_value]
    if new_value
      return new_value.to_i
    else
      raise "mapping for #{unmapped_value} is out of bounds"
    end
  end

  # Set the remapping with a text blob
  #
  # == Parameters:
  # unparsed_txt::
  #   The manually formatted txt blob that represent all the choice options
  # == Return:
  #   Hash with the parsed options
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
