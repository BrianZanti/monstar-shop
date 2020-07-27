require 'rails_helper'

RSpec.describe "Authorization" do
  describe "as a Visitor" do
    it 'cannot visit the merchant namespace' do
      visit '/merchant'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the admin namespace' do
      visit '/admin'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end

    it 'cannot visit the profile page' do
      visit '/profile'

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
      expect(page.status_code).to eq(404)
    end
  end
end
