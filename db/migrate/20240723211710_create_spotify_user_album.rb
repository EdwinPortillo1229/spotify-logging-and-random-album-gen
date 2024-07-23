class CreateSpotifyUserAlbum < ActiveRecord::Migration[7.1]
  def change
    create_table :spotify_user_albums do |t|
      t.references :spotify_user, null: false, foreign_key: true
      t.references :spotify_album, null: false, foreign_key: true

      t.timestamps
    end

    add_index :spotify_user_albums, [:spotify_user_id, :spotify_album_id], unique: true, name: 'index_spotify_user_albums_on_user_id_and_album_id'
  end
end
