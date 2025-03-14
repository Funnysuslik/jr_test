class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings
  validates :ip, presence: true
  validate :validate_ip_format

  private

  def validate_ip_format
    IPAddr.new(ip)
  rescue ArgumentError
    errors.add(:ip, "must be a valid IPv4 or IPv6 address")
  end
end
