class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :name, :address, :city, :state, :zip
  enum role: [:default, :merchant_employee, :admin]

  has_secure_password

  has_many :orders
  belongs_to :merchant, optional: true
end
