# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Monk", description: "Comedy crime procedural about detective with severe OCD.", small_cover_url: 'tmp/monk.jpg', large_cover_url: 'tmp/monk_large.jpg')
Video.create(title: "Futurama", description: "Future comedy about pizza delivery boy who wakes up 1000 years later.", small_cover_url: 'tmp/futurama.jpg', large_cover_url: 'tmp/futurama_large.jpg')
Video.create(title: "South Park", description: "Crude but funny. South Park mocks every aspect of life. Every aspect!", small_cover_url: 'tmp/south_park.jpg', large_cover_url: 'tmp/south_park_large.jpg')
Video.create(title: "Family Guy", description: "Pokes fun at most aspects of American life.", small_cover_url: 'tmp/family_guy.jpg', large_cover_url: 'tmp/family_guy_large.jpg')

Category.create(name: "TV Comedies")
Category.create(name: "Cartoons")
Category.create(name: "TV Drama")

Categorization.create(video_id: 1, category_id: 1)
Categorization.create(video_id: 2, category_id: 1)
Categorization.create(video_id: 3, category_id: 1)
Categorization.create(video_id: 4, category_id: 1)
Categorization.create(video_id: 2, category_id: 2)
Categorization.create(video_id: 3, category_id: 2)
Categorization.create(video_id: 4, category_id: 2)
Categorization.create(video_id: 1, category_id: 3)