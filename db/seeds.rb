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
  'foo'
]

55.times do |n|
  c = Card.new(
    head: "head-#{n}",
    tail: "tail-#{n}",
    memo: "memo-#{n}",
    check: (1..100).to_a.sample,
    status: (0..2).to_a.sample,
    tag_list: tag_list.sample
  )

  if c.save
    puts "SUCCESS: id => #{c.id}"
  else
    puts "FAILED: #{c.errors.messages}"
  end
end
