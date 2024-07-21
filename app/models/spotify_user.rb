class SpotifyUser < ActiveRecord::Base
  SCOPES = %w(user-library-read user-read-email user-read-private user-library-modify)
  SPOTIFY_URL = "https://accounts.spotify.com/authorize?"
  CLIENT_ID = "a2cb6f3e5f7340c3a1ed328590fab4b2"
  CLIENT_SECRET = "d974eb738ed24ae0bcb6efdb279f782e"
  REDIRECT_URI_LINK = "http://127.0.0.1:3000/link_spotify"
  REDIRECT_URI_LINKED = "http://127.0.0.1:3000/linked_spotify"

  def self.generate_state
    SecureRandom.hex(16)
  end

  def self.generate_spotify_authorize_url
    state_param = "state=#{self.generate_state}"
    scopes_param = "scopes=#{SCOPES.join(" ")}"
    redirect_uri_param = "redirect_uri=#{REDIRECT_URI_LINK}"
    client_id_param = "client_id=#{CLIENT_ID}"

    "#{SPOTIFY_URL}?#{state_param}&#{scopes_param}&#{redirect_uri_param}&#{client_id_param}&response_type=code"
  end

  def self.generate_spotify_token_post_url(code)
    client_substring = "#{CLIENT_ID}:#{CLIENT_SECRET}"
    form = {
      code: code,
      redirect_uri: REDIRECT_URI_LINKED,
      grant_type: 'authorization_code'
    }

    headers = {
      'content-type'=> 'application/x-www-form-urlencoded',
      'Authorization' => "basic #{Base64.encode(CLIENT_ID + CLIENT_SECRET)}"
    }
  end
end
