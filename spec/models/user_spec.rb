require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }

  it { should validate_uniqueness_of(:email) }

  it 'generates a random token when user is created' do
    lisa = Fabricate(:user)
    expect(lisa.token).to be_present
  end
end