class ChoiceOptionSet < ActiveRecord::Base
  belongs_to :itembank
  has_many :items, primary_key: :choice_options_id
  store :choice_options

  alias_attribute :cat, :choice_options
  alias_attribute :antwoord_id, :choice_options_id

  validates :choice_options, presence: true
  validates :choice_options_id, presence: true

  def text_for value
    choice_options.keys[choice_options.values.index(value)]
  end

  def choice_options= unparsed_txt
    choice_options_hash = {}
    if unparsed_txt.class == Hash
      choice_options_hash = unparsed_txt
    else
      unparsed_txt.strip.split("\n").each do |option|
        options_split = option.split("=")
        value = options_split.first.strip.to_i
        desc = options_split.last.strip
        choice_options_hash[desc]=value
      end
    end
    write_attribute(:choice_options, choice_options_hash)
  end
end
