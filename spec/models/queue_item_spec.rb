require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

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
    it "returns nil when the rating is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rate).to eq(nil)
    end
  end

  describe "#rate=(new_rate)" do
    it "changes the rate if rating already exists" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      rating = Fabricate(:rating, video: video, user: user, rate: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rate = 2
      expect(Rating.first.rate).to eq(2)
    end
    it "creates a rating with rate if rating does not exist" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rate = 2
      expect(Rating.first.rate).to eq(2)
    end
  end

  describe "#category_name" do
    it "returns first category name of video" do
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