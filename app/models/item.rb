class Item < ActiveRecord::Base
  belongs_to :itembank
  belongs_to :choice_option_set, primary_key: :choice_options_id

  accepts_nested_attributes_for :choice_option_set

  default_scope -> {where("items.choice_option_set_id IS NOT NULL")} # mochten genegeerd worden volgens Muirne (20 april 2015)

  def reverse_scale= value
    if value.to_s.strip.downcase == "ja"
      value = true
    end
    write_attribute(:reverse_scale, value)
  end
end
