class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings
  validates :ip, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validate :validate_ip_format

  def self.top_rated(limit)
    left_joins(:ratings)
      .select("posts.*, COALESCE(AVG(ratings.value), 0) as avg_rating")
      .group("posts.id")
      .order("avg_rating DESC")
      .limit(limit)
  end

  def self.create_post(params)
    user = User.find_or_initialize_by(login: params[:user_login])
    user.save! if user.new_record?

    create(
      title: params[:title],
      body: params[:body],
      user: user,
      ip: params[:ip]
    )
  end

  def self.authors_with_shared_ips
    joins(:user)
      .group(:ip)
      .select("ip, array_agg(distinct users.login) as authors")
      .having("count(distinct user_id) > 1")
      .map { |p| { ip: p.ip, authors: p.authors } }
  end

  private

  def validate_ip_format
    IPAddr.new(ip)
  rescue ArgumentError
    errors.add(:ip, "must be a valid IPv4 or IPv6 address")
  end
end
