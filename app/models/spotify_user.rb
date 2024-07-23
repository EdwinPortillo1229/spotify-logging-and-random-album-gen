class SpotifyUser < ActiveRecord::Base
  has_many :spotify_user_albums
  has_many :spotify_albums, through: :spotify_user_albums

  SCOPES = %w(user-library-read user-read-email user-read-private user-library-modify)
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  CLIENT_ID = "a2cb6f3e5f7340c3a1ed328590fab4b2"
  CLIENT_SECRET = "3333183bf89e4639a8a8a549dde8a9e3"
  REDIRECT_URI_LINK = "http://127.0.0.1:3000/link_spotify"

  def self.generate_state
    SecureRandom.hex(16)
  end

  def self.generate_spotify_authorize_url
    state_param = "state=#{self.generate_state}"
    scopes_param = "scope=#{SCOPES.join(" ")}"
    redirect_uri_param = "redirect_uri=#{REDIRECT_URI_LINK}"
    client_id_param = "client_id=#{CLIENT_ID}"

    "#{SPOTIFY_URL}?#{state_param}&#{scopes_param}&#{redirect_uri_param}&#{client_id_param}&response_type=code"
  end

  def self.get_access_token(code)
    client_substring = "#{CLIENT_ID}:#{CLIENT_SECRET}"

    data = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: REDIRECT_URI_LINK
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
    all_albums = []
    next_url = "https://api.spotify.com/v1/me/albums?limit=50"
    while next_present
      response = HTTParty.get(next_url,
        headers: {
          'Authorization' => "Bearer #{self.access_token}",
          'Content-Type' => 'application/json'
        }
      )

      if response["next"].present?
        next_url = response["next"]
      else
        next_present = false
      end

      response["items"].each do |album|
        album = album["album"]
        debugger

        all_albums << {
          artist: album["artists"][0]["name"],
          album_id: album["id"],
          album_name: album["name"],
          release_date: album["release_date"],
          api_href: album["href"],
          spotify_url: album["external_urls"]["spotify"],
          total_tracks: album["total_tracks"]&.to_i,
          image_url: album["images"][0]["url"],
        }

        number_album = number_album + 1
      end
    end

    all_albums
  end
end
