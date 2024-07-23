class SpotifyUserAlbum < ActiveRecord::Base
  belongs_to :spotify_user
  belongs_to :spotify_album
end
