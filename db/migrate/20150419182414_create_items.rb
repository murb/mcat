class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :variable_name
      t.string :instruction
      t.integer :choice_option_set_id
      t.boolean :reverse_scale
      t.string :item_stem
      t.float :ff_beta1
      t.float :ff_beta2
      t.float :ff_beta3
      t.float :ff_beta4
      t.float :ff_alpha
      t.float :fat_beta1
      t.float :fat_beta2
      t.float :fat_beta3
      t.float :fat_beta4
      t.float :fat_alpha
      t.float :soc_beta1
      t.float :soc_beta2
      t.float :soc_beta3
      t.float :soc_beta4
      t.float :soc_alpha
      t.integer :itembank_id

      t.timestamps #null: false
    end
  end
end
