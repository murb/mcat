require 'rails_helper'

RSpec.describe "participants/edit", type: :view do
  before(:each) do
    @participant = assign(:participant, Participant.create!(
      :session => "MyString",
      :invite_hash => "MyString",
      :participant_hash => "MyString",
      :age => 1,
      :gender => "MyString"
    ))
  end

  it "renders the edit participant form" do
    render

    assert_select "form[action=?][method=?]", participant_path(@participant), "post" do

      assert_select "input#participant_session[name=?]", "participant[session]"

      assert_select "input#participant_invite_hash[name=?]", "participant[invite_hash]"

      assert_select "input#participant_participant_hash[name=?]", "participant[participant_hash]"

      assert_select "input#participant_age[name=?]", "participant[age]"

      assert_select "input#participant_gender[name=?]", "participant[gender]"
    end
  end
end
