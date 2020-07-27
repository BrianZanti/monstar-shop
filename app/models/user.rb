class User < ApplicationRecord
  enum role: [:default, :merchant_admin, :admin]
end
