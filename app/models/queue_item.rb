class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  def video_title
    video.title
  end

  def rate
    rating = Rating.where(user_id: user.id, video_id: video.id).first
    if rating
      rating.rate
    else
      "Not Rated"
    end
  end

  def category_name
    video.categories.first.name
  end

  def category
    video.categories.first
  end

  def self.update_queue_items(@queue_item_data)
    if unique_positions? && only_integers? && belongs_to_current_user?
      new_queue_position_numbers
      normalize_position_numbers
    end
  end

  private

  def self.new_queue_position_numbers
    @queue_item_data.each do |item_data|
      queue_item = QueueItem.find(item_data["id"])
      queue_item.update_attributes(position: item_data["position"])
    end
  end

  def self.normalize_position_numbers
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def self.unique_positions?
    @queue_item_data.map { |queue_item| queue_item[:position] }.length == @queue_item_data.map { |queue_item| queue_item[:position] }.uniq.length
  end

  def self.only_integers?
    positions = @queue_item_data.map { |queue_item| queue_item[:position]  }
    positions.length == positions.map(&:to_i).reject {|i| i==0}.length
  end

  def self.belongs_to_current_user?
    users = @queue_item_data.map { |item_data| QueueItem.find(item_data["id"]).user }
    users.length == users.reject { |u| u != current_user }.length
  end
end