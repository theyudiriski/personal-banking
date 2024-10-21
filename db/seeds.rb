puts 'Seeding started...'

user1 = User.create!(
  name: 'Yudi Riski Chandratama',
  email: 'yudi.chandratama@gmail.com'
)

Wallet.create!(user: user1, balance: 1000.0)

user2 = User.create!(
  name: 'Kurniawan',
  email: 'kurniawan@gmail.com'
)

Wallet.create!(user: user2, balance: 500.0)

puts 'Seeding completed successfully!'
