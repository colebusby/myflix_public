require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'movie1')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('movie1')
    end
  end

  describe "#rate" do
    it "returns the rate from the rating when the rating is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      rating = Fabricate(:rating, user: user, video: video, rate: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rate).to eq(4)
    end
    it "returns 'Not Rated' when the rating is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rate).to eq('Not Rated')
    end
  end

  describe "#category_name" do
    it "returns one of the category names of video" do
      video = Fabricate(:video)
      comedy = Fabricate(:category, name: "Comedy")
      video.categories << comedy
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#category" do
    it "returns category object" do
      video = Fabricate(:video)
      category = Fabricate(:category, name: "Comedy")
      video.categories << category
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end