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
    if params[:spotify_user_id].blank? || (user = SpotifyUser.find(params[:spotify_user_id])).blank?
      redirect_to "/"
    end

    if user.spotify_albums&.last.blank?
      redirect_to "/load_albums_page/#{user.id}"
    end

    @user_id = params[:spotify_user_id]
  end

  def get_random_albums
    if params[:spotify_user_id].blank? || (user = SpotifyUser.find(params[:spotify_user_id])).blank?
      redirect_to "/"
    end

    albums = user.grab_five_random_albums

    if albums.blank?
      render json: { success: false, message: "No albums found" }, status: 400
    else
      render json: { success: true, albums: albums }, status: 200
    end
  end

  def load_albums_page
    if params[:spotify_user_id].blank? || (user = SpotifyUser.find(params[:spotify_user_id])).blank?
      redirect_to "/"
    end

    if user.spotify_albums.last.present?
      @header_text = "Please click the button below to get an up-to-date album library to pick from!"
    else
      @header_text ="It seems we don't have your library, please click below to grab em!"
    end

    @user_id = params[:spotify_user_id]
  end

  def load_albums
    if params[:spotify_user_id].blank? || (user = SpotifyUser.find(params[:spotify_user_id])).blank?
      render json: { success: false, error: "Spotify User ID missing" }, status: 400
    end

    user.load_albums!
    render json: { success: true }, status: 200
  end
end
