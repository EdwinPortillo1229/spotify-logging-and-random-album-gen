class SpotifyController < ActionController::Base
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  SCOPES="user-library-read user-read-email user-read-private"

  def spotify
    ##noop
  end

  def link_spotify
    code = params["code"]

    url = SpotifyUser.generate_spotify_token_post_url(code)

    ##gotta do a post to 'https://accounts.spotify.com/api/token'
    ##https://developer.spotify.com/documentation/web-api/tutorials/code-flow
  end

  def linked_spotify
  end
end
