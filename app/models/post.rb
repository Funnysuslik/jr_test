class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  validates :ip,
    presence: true,
    format: {
      with: /\A(?:([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4})\z/,
      message: "must be a valid IPv4 or IPv6 address"
    }
end
