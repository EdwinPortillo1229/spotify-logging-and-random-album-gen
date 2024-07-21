class CreateSpotifyUser < ActiveRecord::Migration[7.1]
  def change
    create_table :spotify_users do |t|
      t.string :display_name
      t.string :external_id

      t.timestamps
    end
  end
end
