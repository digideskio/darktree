# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

cards = [
  {
    head: 'ペンを借りてもいい？',
    tail: 'Can I borrow your pen?',
    memo: 'キクタン英会話 Day1 Chapter1',
    check: 0,
    status: 0
  },
  {
    head: 'トムはパーティに来るの？',
    tail: 'Is Tom coming to the party?',
    memo: 'キクタン英会話 Day2 Chapter1',
    check: 0,
    status: 0
  },
  {
    head: '新しい仕事が見つかりました！',
    tail: 'I found a new job!',
    memo: '',
    check: 0,
    status: 1
  },
]

cards.each do |card|
  Card.create(card)
end
