# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)






# create_account = User.create([email: 'example@gmail.com', password: '12345678', password_confirmation: '12345678', is_admin: 'true'])
# puts "Admin account created."

category_info = [
 "教练",
 "俱乐部经理",
 "足球宝贝",
 "球探",
]

create_jobs = for i in 1..10 do
  c = category_info[rand(category_info.length)]
  Job.create!([title: "#{i}#{c}" , category: c , description: "這是用種子建立的第 #{i} 個Public工作", wage_upper_bound: rand(50..99)*100, wage_lower_bound: rand(10..49)*100, is_hidden: "false"])
end
puts "10 Hidden jobs create"
