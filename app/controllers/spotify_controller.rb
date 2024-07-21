class SpotifyController < ActionController::Base
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  SCOPES="user-library-read user-read-email user-read-private"

  def spotify
    ##noop
  end

  def link_spotify
    code = params["code"]
    get_access_token = SpotifyUser.get_access_token(code)

    if get_access_token[:success]
      access_res = JSON.parse(get_access_token[:response].body)
      basic_info_res = SpotifyUser.get_basic_info(access_res[:access_token])
    else
      redirect_to "/"
    end

  end

  def linked_spotify
  end
end
