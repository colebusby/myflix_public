require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations) }
  it { validate_presence_of(:name) }
  it { validate_uniqueness_of(:name) }

  describe "#recently_added" do

    let(:comedy) { Fabricate(:category, name: 'comedy') }

    it "orders recently added videos by most recent" do
      monk = Fabricate(:video, created_at: 1.day.ago, categories: [comedy])
      psych = Fabricate(:video, categories: [comedy])
      expect(comedy.recently_added.first).to eq(psych)
    end

    it "selects a maximum of 6 videos" do
      Fabricate.times(8, :video, categories: [comedy])
      comedy.recently_added.count.should == 6
    end

    it "selects all videos if less than 6 available" do
      Fabricate.times(4, :video, categories: [comedy])
      comedy.recently_added.count.should == comedy.videos.count
    end
  end
end