# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

deck_list = [
  'foo,bar,baz,abcdefghijklmnopqrstuvwxyz',
  'foo,bar,baz',
  'foo,bar',
  'foo',
  ''
]

55.times do |n|
  c = Card.new(
    front: "front-#{n}: " + 'H' * [5, 10, 30, 50, 100, 300].to_a.sample,
    back: "back-#{n}: " + 'T' * [5, 10, 30, 50, 100, 300].to_a.sample,
    memo: "memo-#{n}",
    status: (0..2).to_a.sample,
    favorite: [0,1].sample,
    check_count: (0..100).to_a.sample,
    deck_list: deck_list.sample
  )

  if c.save
    puts "SUCCESS: id => #{c.id}"
  else
    puts "FAILED: #{c.errors.full_messages}"
  end
end
