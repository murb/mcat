require 'rails_helper'

RSpec.describe "participants/index", type: :view do
  before(:each) do
    assign(:participants, [
      Participant.create!(
        :session => "Session",
        :invite_hash => "Invite Hash",
        :participant_hash => "Participant Hash",
        :age => 1,
        :gender => "Gender"
      ),
      Participant.create!(
        :session => "Session",
        :invite_hash => "Invite Hash",
        :participant_hash => "Participant Hash",
        :age => 1,
        :gender => "Gender"
      )
    ])
  end

  it "renders a list of participants" do
    render
    assert_select "tr>td", :text => "Session".to_s, :count => 2
    assert_select "tr>td", :text => "Invite Hash".to_s, :count => 2
    assert_select "tr>td", :text => "Participant Hash".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
  end
end
