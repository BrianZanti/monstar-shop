require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should have_secure_password }
  end

  describe 'relationships' do
    it { should have_many :orders }
  end

  describe 'roles' do
    it 'is default by default' do
      user = create(:user)
      expect(user.role).to eq("default")
      expect(user.default?).to be(true)
      expect(user.admin?).to be(false)
      expect(user.merchant_employee?).to be(false)
    end

    it 'can be a merchant employee' do
      user = create(:merchant_employee)
      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be(true)
      expect(user.default?).to be(false)
      expect(user.admin?).to be(false)
    end

    it 'can be an admin' do
      user = create(:admin)
      expect(user.role).to eq("admin")
      expect(user.admin?).to be(true)
      expect(user.default?).to be(false)
      expect(user.merchant_employee?).to be(false)
    end
  end
end
