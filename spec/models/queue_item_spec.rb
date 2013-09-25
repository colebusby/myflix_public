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

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      rating = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end
    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#rating=(new_rating)" do
    it "changes the rating if review already exists" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 2
      expect(Review.first.rating).to eq(2)
    end
    it "creates a review with rating if review does not exist" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.rating = 2
      expect(Review.first.rating).to eq(2)
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