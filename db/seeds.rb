# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

tag_list = [
  'foo,bar,baz',
  'foo,bar',
  'foo',
  ''
]

55.times do |n|
  c = Card.new(
    head: "head-#{n}: " + 'H' * [5, 10, 30, 50, 100, 300].to_a.sample,
    tail: "tail-#{n}: " + 'T' * [5, 10, 30, 50, 100, 300].to_a.sample,
    memo: "memo-#{n}",
    check: (1..100).to_a.sample,
    status: (0..2).to_a.sample,
    tag_list: tag_list.sample
  )

  if c.save
    puts "SUCCESS: id => #{c.id}"
  else
    puts "FAILED: #{c.errors.full_messages}"
  end
end
