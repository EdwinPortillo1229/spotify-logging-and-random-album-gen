class SpotifyUser < ActiveRecord::Base
  has_many :spotify_user_albums
  has_many :spotify_albums, through: :spotify_user_albums

  SCOPES = %w(user-library-read user-read-private user-library-modify)
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  CLIENT_ID = "a2cb6f3e5f7340c3a1ed328590fab4b2"
  CLIENT_SECRET = "30e36aa57f5a444591cb463a5ca128fa"
  REDIRECT_URI_LINK_PROD = "https://spotify-random-liked-albums-cde946bf36b7.herokuapp.com/link_spotify"
  REDIRECT_URI_LINK_DEV = "http://127.0.0.1:3000/link_spotify"

  def self.generate_state
    SecureRandom.hex(16)
  end

  def self.generate_spotify_authorize_url
    state_param = "state=#{self.generate_state}"
    scopes_param = "scope=#{SCOPES.join(" ")}"
    redirect_uri_param = Rails.env.production? ? "redirect_uri=#{REDIRECT_URI_LINK_PROD}" : "redirect_uri=#{REDIRECT_URI_LINK_DEV}"
    client_id_param = "client_id=#{CLIENT_ID}"

    "#{SPOTIFY_URL}?#{state_param}&#{scopes_param}&#{redirect_uri_param}&#{client_id_param}&response_type=code"
  end

  def self.get_access_token(code)
    client_substring = "#{CLIENT_ID}:#{CLIENT_SECRET}"

    proper_link = Rails.env.production? ? REDIRECT_URI_LINK_PROD : REDIRECT_URI_LINK_DEV
    data = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: proper_link
    }

    encoded_data = data.map { |k,v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')

    headers = {
      'content-type'=> 'application/x-www-form-urlencoded',
      'Authorization' => "basic #{Base64.strict_encode64(client_substring)}"
    }
   
    response = HTTParty.post(
      "https://accounts.spotify.com/api/token",
      headers: headers,
      body: encoded_data
    )

    if response.code == 200
      { success: true, response: response }
    else
      { success: false, error: "#{response.message}: #{response.body}" }
    end
  end

  def self.create_or_find_spotify_user(access_token)
    response = HTTParty.get(
      "https://api.spotify.com/v1/me",
      headers: {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      }
    )

    if response.code != 200
      return { success: false, error: response.body }
    end

    res = JSON.parse(response.body)

    user = SpotifyUser.find_or_initialize_by(external_id: res["id"])
    user.access_token = access_token if (user.access_token != access_token)
    user.save!

    { success: true, user: user }
  end

  def load_albums!()
    number_album = 0
    next_present = true
    album_ids = self.spotify_album_ids

    next_url = "https://api.spotify.com/v1/me/albums?limit=50"
    while next_present
      response = HTTParty.get(next_url,
        headers: {
          'Authorization' => "Bearer #{self.access_token}",
          'Content-Type' => 'application/json'
        }
      )

      if response.code != 200
        return { success: false, error: response.body }
      end

      if response["next"].present?
        next_url = response["next"]
      else
        next_present = false
      end

      response["items"].each do |album_data|
        album_data = album_data["album"]
        next if album_data["album_type"] == "single"

        album = SpotifyAlbum.find_by(external_id: album_data["id"])

        if !album.present?
          album = SpotifyAlbum.new 
          album.artist       = album_data["artists"][0]["name"]
          album.name         = album_data["name"]
          album.release_date = album_data["release_date"]
          album.api_href     = album_data["href"]
          album.spotify_url  = album_data["external_urls"]["spotify"]
          album.total_tracks = album_data["total_tracks"]&.to_i
          album.image_url    = album_data["images"][0]["url"]
          album.album_type   = album_data["album_type"]
          album.external_id  = album_data["id"]
          album.save!

          self.spotify_user_albums.create!(spotify_album_id: album.id)
          next
        end

        ##make sure the connection is there
        if self.spotify_user_albums.find_by(spotify_album_id: album.id).present?
          puts("\n deleting #{album.name}")
          album_ids.delete(album.id)
          next
        end

        self.spotify_user_albums.create!(spotify_album_id: album.id)
      end
    end

    ##if we didnt find the album, delete it!
    self.spotify_user_albums.where(spotify_album_id: album_ids).destroy_all

    return { success: true }
  end

  def grab_five_random_albums
    five_album_ids = self.spotify_album_ids&.sample(5)
    self.spotify_albums.where(id: five_album_ids)
  end
end
