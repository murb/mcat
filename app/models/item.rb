class Item < ActiveRecord::Base
  belongs_to :itembank
  default_scope -> {where("items.choice_option_set_id IS NOT NULL")} # mochten genegeerd worden volgens Muirne (20 april 2015)
end
