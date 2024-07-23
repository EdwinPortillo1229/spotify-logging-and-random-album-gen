class CreateSpotifyAlbum < ActiveRecord::Migration[7.1]
  def change
    create_table :spotify_albums do |t|
      t.string :artist
      t.string :external_id
      t.string :name
      t.string :release_date
      t.string :api_href
      t.string :spotify_url
      t.integer :total_tracks
      t.string :image_url

      t.timestamps
    end
  end
end
