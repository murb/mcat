class ChangeBetaAlphaStorageOnItems < ActiveRecord::Migration
  def change

    remove_column :items, "ff_beta1"
    remove_column :items, "ff_beta2"
    remove_column :items, "ff_beta3"
    remove_column :items, "ff_beta4"
    remove_column :items, "ff_alpha"
    remove_column :items, "fat_beta1"
    remove_column :items, "fat_beta2"
    remove_column :items, "fat_beta3"
    remove_column :items, "fat_beta4"
    remove_column :items, "fat_alpha"
    remove_column :items, "soc_beta1"
    remove_column :items, "soc_beta2"
    remove_column :items, "soc_beta3"
    remove_column :items, "soc_beta4"
    remove_column :items, "soc_alpha"

    add_column :items, :parameters, :text

  end
end