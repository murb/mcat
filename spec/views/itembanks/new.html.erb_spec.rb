require 'rails_helper'

RSpec.describe "itembanks/new", type: :view do
  before(:each) do
    assign(:itembank, Itembank.new(
      :name => "MyString",
      :source => "MyString"
    ))
  end

  it "renders new itembank form" do
    render

    assert_select "form[action=?][method=?]", itembanks_path, "post" do

      assert_select "input#itembank_name[name=?]", "itembank[name]"

      assert_select "input#itembank_source[name=?]", "itembank[source]"
    end
  end
end
