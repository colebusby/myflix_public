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
Video.create(title: "Modern Family", description: "A very diverse family and their comical life experiences.", small_cover_url: 'tmp/modern_family.jpg', large_cover_url: 'tmp/modern_family_large.jpg')
Video.create(title: "All in the Family", description: "Pokes fun at most aspects of American life, possibly the inspiration for Family Guy.", small_cover_url: 'tmp/all_in_the_family.jpg', large_cover_url: 'tmp/all_in_the_family_large.jpg')
Video.create(title: "3rd Rock From the Sun", description: "Aliens try to blend in, but they don't succeed.", small_cover_url: 'tmp/3rd_rock_from_the_sun.jpg', large_cover_url: 'tmp/3rd_rock_from_the_sun_large.jpg')
Video.create(title: "Avatar: The Last Air Bender", description: "Ten year old kid saves the world.", small_cover_url: 'tmp/avatar_the_last_air_bender.jpg', large_cover_url: 'tmp/avatar_the_last_air_bender_large.jpg')
Video.create(title: "Continuum", description: "Time traveling cop tries to figure out the past.", small_cover_url: 'tmp/continuum.jpg', large_cover_url: 'tmp/continuum_large.jpg')
Video.create(title: "Downton Abbey", description: "England in the twenties. A soap opera with good acting.", small_cover_url: 'tmp/downton_abbey.jpg', large_cover_url: 'tmp/downton_abbey_large.jpg')
Video.create(title: "Doctor Who", description: "Time traveler has lots of adventures.", small_cover_url: 'tmp/dr_who.jpg', large_cover_url: 'tmp/dr_who_large.jpg')
Video.create(title: "Firefly", description: "Space western about diverse transport crew. Also greatest show of all time.", small_cover_url: 'tmp/firefly.jpg', large_cover_url: 'tmp/firefly_large.jpg')
Video.create(title: "Law & Order: SVU", description: "Crime procedural dealing with victims of sex crimes.", small_cover_url: 'tmp/law_and_order_svu.jpg', large_cover_url: 'tmp/law_and_order_svu_large.jpg')
Video.create(title: "The Big Bang Theory", description: "The intelectually gifted but socially challenged try to hit on hot girls.", small_cover_url: 'tmp/the_big_bang_theory.jpg', large_cover_url: 'tmp/the_big_bang_theory_large.jpg')
Video.create(title: "The Office", description: "Mockumentary about a paper sales office in a small town.", small_cover_url: 'tmp/the_office.jpg', large_cover_url: 'tmp/the_office_large.jpg')

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
Categorization.create(video_id: 5, category_id: 1)
Categorization.create(video_id: 6, category_id: 1)
Categorization.create(video_id: 6, category_id: 3)
Categorization.create(video_id: 7, category_id: 1)
Categorization.create(video_id: 8, category_id: 2)
Categorization.create(video_id: 8, category_id: 3)
Categorization.create(video_id: 9, category_id: 3)
Categorization.create(video_id: 10, category_id: 3)
Categorization.create(video_id: 11, category_id: 3)
Categorization.create(video_id: 12, category_id: 3)
Categorization.create(video_id: 13, category_id: 3)
Categorization.create(video_id: 14, category_id: 1)
Categorization.create(video_id: 15, category_id: 1)

15.times { Fabricate(:user) }

Video.all.each do |video|
  User.all.each do |user|
    Fabricate(:rating, video_id: video.id, user_id: user.id)
  end
end