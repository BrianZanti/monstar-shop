require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :email}
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'roles' do
    it 'is default by default' do
      user = User.create!
      expect(user.role).to eq("default")
      expect(user.default?).to be(true)
      expect(user.admin?).to be(false)
      expect(user.merchant_admin?).to be(false)
    end

    it 'can be a merchant admin' do
      user = User.create!(role: :merchant_admin)
      expect(user.role).to eq("merchant_admin")
      expect(user.merchant_admin?).to be(true)
      expect(user.default?).to be(false)
      expect(user.admin?).to be(false)
    end

    it 'can be an admin' do
      user = User.create!(role: :admin)
      expect(user.role).to eq("admin")
      expect(user.admin?).to be(true)
      expect(user.default?).to be(false)
      expect(user.merchant_admin?).to be(false)
    end
  end
end
