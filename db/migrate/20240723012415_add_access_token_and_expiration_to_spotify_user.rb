class AddAccessTokenAndExpirationToSpotifyUser < ActiveRecord::Migration[7.1]
  def change
    add_column :spotify_users, :access_token, :string
  end
end
