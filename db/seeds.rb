require 'curb'
require 'json'
require 'securerandom'

curl = Curl::Easy.new
curl.headers['Content-Type'] = 'application/json'

200_000.times do |i|
  body = {
    user_login: "user_#{i < 100 ? i : rand(100)}",
    title: "Post Title #{i}",
    body: "This is the content for post #{i}.",
    ip: "192.168.1.#{rand(50)}"
  }

  curl.url = 'http://localhost:3000/api/v1/posts'
  curl.post_body = body.to_json
  curl.perform

  if i >= 100 && rand < 0.75
    rand(1..5).times do
      rating_body = {
        user_id: rand(1..100),
        post_id: i + 1,
        value: rand(1..5)
      }

      curl.url = 'http://localhost:3000/api/v1/ratings'
      curl.post_body = rating_body.to_json
      curl.perform
    end
  end
end
