class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queue_path
  end

  def update_queue
    @queue_items = params[:queue_items]
    if unique_positions? && only_integers?
      new_queue_position_numbers
      normalize_position_numbers
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def new_queue_position_numbers
    @queue_items.each do |queue_item_data|
      queue_item = QueueItem.find(queue_item_data["id"])
      queue_item.update_attributes(position: queue_item_data["position"])
    end
  end

  def normalize_position_numbers
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def unique_positions?
    @queue_items.map { |queue_item| queue_item[:position] }.length == @queue_items.map { |queue_item| queue_item[:position] }.uniq.length
  end

  def only_integers?
    positions = @queue_items.map { |queue_item| queue_item[:position]  }
    positions.length == positions.map(&:to_i).reject {|i| i==0}.length
  end
end