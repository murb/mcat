class AddStatValueToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :stat_value, :integer
  end
end
