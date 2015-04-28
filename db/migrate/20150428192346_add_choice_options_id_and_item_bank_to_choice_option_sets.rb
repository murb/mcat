class AddChoiceOptionsIdAndItemBankToChoiceOptionSets < ActiveRecord::Migration
  def change
    add_column :choice_option_sets, :choice_options_id, :integer
    add_column :choice_option_sets, :itembank_id, :integer
  end
end
