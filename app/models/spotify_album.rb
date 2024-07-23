class SpotifyAlbum < ActiveRecord::Base
  has_many :spotify_user_albums
  has_many :spotify_users, through: :spotify_user_albums
end
