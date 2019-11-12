class AddLatAndLngToUnprocessedImages < ActiveRecord::Migration[6.0]
  def change
    change_table :unprocessed_images, bulk: true do |t|
      t.inet :uploader_ip, null: false
      t.decimal "lat", precision: 10, scale: 7, default: 0.0, null: false
      t.decimal "lng", precision: 10, scale: 7, default: 0.0, null: false
    end
  end
end
