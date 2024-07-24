class AddAlbumTypeToSpotifyAlbum < ActiveRecord::Migration[7.1]
  def change
    add_column(:spotify_albums, :album_type, :string)
  end
end
