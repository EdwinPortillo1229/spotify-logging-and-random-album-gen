class SpotifyController < ActionController::Base
  layout 'application'
  def spotify
    ##noop
  end

  def link_spotify
    code = params["code"]
    get_access_token = SpotifyUser.get_access_token(code)

    if !get_access_token[:success]
      redirect_to "/"
    end

    access_res = JSON.parse(get_access_token[:response].body)
    create_or_find_spotify_user = SpotifyUser.create_or_find_spotify_user(access_res["access_token"])

    if !create_or_find_spotify_user[:success]
      redirect_to "/"
    else
      redirect_to "/random_albums/#{create_or_find_spotify_user[:user].id}"
    end
  end

  def random_albums
    if params[:spotify_user_id].blank?
      redirect_to "/"
    end

    @user_id = params[:spotify_user_id]
  end

  def get_random_albums
    if params[:spotify_user_id].blank?
      redirect_to "/"
    end

    user = SpotifyUser.find(params[:spotify_user_id])
    albums = user.grab_five_random_albums

    render json: { success: true, albums: albums }
  end

  def load_albums
    if params[:spotify_user_id].blank?
      return { success: false, error: "Spotify User ID missing" }
    end
    user = SpotifyUser.find(params[:spotify_user_id])
  end
end
