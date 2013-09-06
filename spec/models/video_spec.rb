require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "TNMT", description: "Heroes in a half-shell!", small_cover_url: "www.tnmt.com", large_cover_url: "www.imdb.com")
    video.save
    Video.find_by(title: "TNMT").title.should == "TNMT"
    Video.find_by(title: "TNMT").description.should == "Heroes in a half-shell!"
  end

  it { should have_many(:categories).through(:categorizations) }

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description)}

  describe "video search" do
    it "returns == 1 if a video containing search_term in video.title found" do
      Video.create(title: "movie1", description: "a movie")
      Video.create(title: "movie2", description: "a movie again")
      Video.search_by_title("movie1").count.should == 1
    end
    it "returns > 1 if multiple videos containing search_term in video.title found" do
      Video.create(title: "movie1", description: "a movie")
      Video.create(title: "movie2", description: "a movie again")
      Video.search_by_title("movie").count.should > 1
    end
    it "returns 0 if no video containing search_term in video.title found" do
      Video.create(title: "movie1", description: "a movie")
      Video.create(title: "movie2", description: "a movie again")
      Video.search_by_title("tvshow").count.should == 0
    end
  end
end

