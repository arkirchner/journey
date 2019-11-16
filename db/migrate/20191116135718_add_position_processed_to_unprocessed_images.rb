class AddPositionProcessedToUnprocessedImages < ActiveRecord::Migration[6.0]
  def change
    add_column :unprocessed_images, :position_processed, :boolean, null: false, default: false
  end
end
