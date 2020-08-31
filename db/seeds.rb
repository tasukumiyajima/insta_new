# 管理者ユーザーを1人作成する
User.create!(name:  "Admin User",
             user_name: "Admin",
             email: "admin@railstutorial.org",
             password: "passwordpassword",
             website: "https://www.youtube.com/",
             introduction: "管理者やってます。ruby on railsの勉強中です。宜しくお願いします。",
             phone_number: 111222333,
             sex: 1,
             admin: true)

# メインのサンプルユーザーを1人作成する
User.create!(name:  "テストユーザー",
             user_name: "テスト",
             email: "example@user.com",
             password: "password",
             website: "https://camp.potepan.com/",
             introduction: "テストユーザーやってます。この自己紹介文は書き換えてもらって大丈夫です。",
             phone_number: 111222333,
             sex: 1 )

# 追加のユーザーをまとめて生成する
60.times do |n|
  name  = Faker::Name.name
  user_name = Faker::Games::Pokemon.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  website = "https://camp.potepan.com/"
  introduction = Faker::Lorem.sentence
  User.create!(name: name,
               user_name: user_name,
               email: email,
               password: password,
               website: website,
               introduction: introduction)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
10.times do |n|
  content = Faker::Games::Pokemon.move
  picture = open("db/fixtures/img#{n+1}.jpg")
  users.each { |user| user.microposts.create!(content: content, picture: picture) }
end

# マイクロポストの一部を対象にコメントを生成する
microposts = Micropost.all
user  = users.second
comented_micropost = microposts[1..20]
comment = Faker::Games::Pokemon.location
comented_micropost.each { |micropost| user.comments.create!(content: comment, micropost_id: micropost.id) }

# サンプルユーザーのフォロワーとフォロー中を作成する
users = User.all
user  = users.second
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
