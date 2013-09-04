require 'spec_helper'

describe Category do
  it "has many videos" do
    Category.create(name: "cat1")
    Video.create(title: "vid1")
    Video.create(title: "vid2")
    Categorization.create(video_id: 1, category_id: 1)
    Categorization.create(video_id: 2, category_id: 1)
    Category.first.videos.count.should == 2
  end
end