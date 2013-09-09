require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations) }

  it { validate_presence_of(:name) }

  it { validate_uniqueness_of(:name) }

  describe "recently added videos" do
    it "orders videos by most recent" do
      sample = Category.create(name: 'sample')
      i = 1
      6.times do
        video = Video.create(title: "movie#{i}", description: "a movie", categories: [sample])
        i += 1
      end
      sample.recently_added[0].created_at.should > sample.recently_added[1].created_at
      sample.recently_added[1].created_at.should > sample.recently_added[2].created_at
    end
    it "selects a maximum of 6 videos" do
      sample = Category.create(name: 'sample')
      i = 1
      8.times do
        video = Video.create(title: "movie#{i}", description: "a movie", categories: [sample])
        i += 1
      end
      sample.recently_added.count.should == 6
    end
    it "selects all videos if less than 6 available" do
      sample = Category.create(name: 'sample')
      i = 1
      4.times do
        video = Video.create(title: "movie#{i}", description: "a movie", categories: [sample])
        i += 1
      end
      sample.recently_added.count.should == sample.videos.count
    end
  end
end