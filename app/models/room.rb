class Room < ApplicationRecord
  enum access: [:public_access, :private_access]
  has_secure_password validations: false
  has_secure_token

  has_many :table_items

  validates :name, presence: true

  before_save :set_access

  private

  def set_access
    self.access = (password || password_digest) ? :private_access : :public_access
  end
end
