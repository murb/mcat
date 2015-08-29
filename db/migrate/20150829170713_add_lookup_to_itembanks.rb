class AddLookupToItembanks < ActiveRecord::Migration
  def change
    add_column :itembanks, :lookup, :string
  end
end
