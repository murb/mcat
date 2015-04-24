require 'rails_helper'

RSpec.describe "participants/new", type: :view do
  before(:each) do
    assign(:participant, Participant.new(
      :session => "MyString",
      :invite_hash => "MyString",
      :participant_hash => "MyString",
      :age => 1,
      :gender => "MyString"
    ))
  end

  it "renders new participant form" do
    render

    assert_select "form[action=?][method=?]", participants_path, "post" do

      assert_select "input#participant_session[name=?]", "participant[session]"

      assert_select "input#participant_invite_hash[name=?]", "participant[invite_hash]"

      assert_select "input#participant_participant_hash[name=?]", "participant[participant_hash]"

      assert_select "input#participant_age[name=?]", "participant[age]"

      assert_select "input#participant_gender[name=?]", "participant[gender]"
    end
  end
end
