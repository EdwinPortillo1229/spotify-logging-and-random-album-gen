class SpotifyController < ActionController::Base
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  SCOPES="user-library-read user-read-email user-read-private"

  def spotify
    ##noop
  end

  def link_spotify
    code = params["code"]

    authorization_res = SpotifyUser.get_authorization_code(code)
  end

  def linked_spotify
  end
end
