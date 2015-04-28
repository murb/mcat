class Itembank < ActiveRecord::Base
  mount_uploader :source, WorkbookUploader
  after_save :parse_items!
  has_many :items
  has_many :choice_option_sets, primary_key: :choice_options_id

  def source_as_workbook
    @source_as_workbook ||= Workbook::Book.open(source.file.file)
  end

  def parse_items!
    items.destroy_all
    choice_option_sets.destroy_all
    header = nil
    source_as_workbook.first.first.each do |row|
      if header == nil
        header = row
      else
        item = Item.new(itembank: self)
        row.to_hash.each do |key, value|
          item.public_send("#{key}=", (value ? value.value : nil))
        end
        item.save
      end
    end
    header = nil
    source_as_workbook.last.first.each do |row|
      if header == nil
        header = row
      else
        item = ChoiceOptionSet.new(itembank: self)
        row.to_hash.each do |key, value|
          item.public_send("#{key}=", (value ? value.value : nil))
        end
        item.save
      end
    end
  end
end
