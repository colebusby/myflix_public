require 'spec_helper'

describe Category do
  it { should have_many(:videos).through(:categorizations) }

  it { validate_presence_of(:name) }

  it { validate_uniqueness_of(:name) }
end