require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "TNMT", description: "Heroes in a half-shell!", small_cover_url: "www.tnmt.com", large_cover_url: "www.imdb.com")
    video.save
    Video.first.title.should == "TNMT"
    Video.first.description.should == "Heroes in a half-shell!"
  end

  it "has many categories" do
    video = Video.create(title: "TNMT", description: "Heroes in a half-shell!", small_cover_url: "www.tnmt.com", large_cover_url: "www.imdb.com")
    Category.create(name: "cat1")
    Category.create(name: "cat2")
    Categorization.create(video_id: 1, category_id: 1)
    Categorization.create(video_id: 1, category_id: 2)
    Video.first.categories.count.should == 2
  end
end