class RenameRateColumnToRating < ActiveRecord::Migration
  def change
    rename_column :reviews, :rate, :rating
  end
end
