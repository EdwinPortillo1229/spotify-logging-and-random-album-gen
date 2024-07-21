class SpotifyController < ActionController::Base
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  SCOPES="user-library-read user-read-email user-read-private"

  def linked_spotify
  end
end
