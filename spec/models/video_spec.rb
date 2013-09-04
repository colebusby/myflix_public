require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "TNMT", description: "Heroes in a half-shell!", small_cover_url: "www.tnmt.com", large_cover_url: "www.imdb.com")
    video.save
    Video.first.title.should == "TNMT"
    Video.first.description.should == "Heroes in a half-shell!"
  end

  it { should have_many(:categories).through(:categorizations) }

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description)}
end