class CreateIpLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :ip_locations, id: false do |t|
      t.inet :ip, primary: true
      t.decimal "lat", precision: 10, scale: 7, defaul: 0.0, null: false
      t.decimal "lng", precision: 10, scale: 7, defaul: 0.0, null: false

      t.timestamps
    end
  end
end
