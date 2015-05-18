require 'rails_helper'

RSpec.describe "invites/index", type: :view do
  before(:each) do
    assign(:invites, [
      Invite.create!(
        :hash => "Hash",
        :comments => "MyText",
        :examinator_id => 1,
        :participant_id => 2
      ),
      Invite.create!(
        :hash => "Hash",
        :comments => "MyText",
        :examinator_id => 1,
        :participant_id => 2
      )
    ])
  end

  it "renders a list of invites" do
    render
    assert_select "tr>td", :text => "Hash".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
