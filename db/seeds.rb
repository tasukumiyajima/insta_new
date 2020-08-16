# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             user_name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  user_name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               user_name: user_name,
               email: email,
               password: password)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 2)
  picture = open('db/fixtures/kitten.jpg')
  users.each { |user| user.microposts.create!(content: content, picture: picture) }
end

# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

