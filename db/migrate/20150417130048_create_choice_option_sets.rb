class CreateChoiceOptionSets < ActiveRecord::Migration
  def change
    create_table :choice_option_sets do |t|
      t.text :choice_options

      t.timestamps null: false
    end
  end
end
