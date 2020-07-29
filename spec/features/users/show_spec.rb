require 'rails_helper'

RSpec.describe "User Profile Page" do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "shows all the users info" do
    visit profile_path

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip)
    expect(page).to have_content(@user.email)
  end

  it "has a link to the edit form that is prepopulated" do
    visit profile_path

    click_link 'Edit Profile'

    expect(current_path).to eq(user_edit_path)
    expect(find('#user_name').value).to eq(@user.name)
    expect(find('#user_address').value).to eq(@user.address)
    expect(find('#user_city').value).to eq(@user.city)
    expect(find('#user_state').value).to eq(@user.state)
    expect(find('#user_zip').value).to eq(@user.zip)
    expect(find('#user_email').value).to eq(@user.email)
  end
end
