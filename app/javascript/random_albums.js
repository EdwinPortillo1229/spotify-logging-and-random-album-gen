document.addEventListener('DOMContentLoaded', () => {
  const createAlbumUI = (data) => {
    const randomAlbumContainer = document.querySelector("#randomized-albums-container");

    let albumDivs = '';

    data.forEach(album => {
      albumDivs += `
        <div class="album-div">
          <div class="image-container">
            <img src="${album.image_url}" class="album-image">
          </div>
          <div class="album-info-container">
            <p class="album-title">
              <b>Title:</b> <i>${album.name}</i>
            </p>
            <p class="album-artist">
              <b>Artist:</b> <i>${album.artist}</i>
            </p>
            <p class="album-release_date">
              <b>Release Date:</b> <i>${album.release_date}</i>
            </p>
            <p class="album-total_tracks">
              <b>Number of Tracks:</b> <i>${album.total_tracks}</i>
            </p>
            <a target="_blank" class="spotify-link" href="${album.spotify_url}">
              <img class="spotify-logo-image" src="/assets/spotify_logo.png">
            </a>
          </div>
        </div>
      `
    });

    randomAlbumContainer.innerHTML = albumDivs;
  }

  const randomizer = document.querySelector('#get-random-albums-link');
  randomizer.addEventListener('click', async (e) => {
    e.preventDefault();
    const randomAlbumContainer = document.querySelector("#randomized-albums-container");
    randomAlbumContainer.innerHTML = '';
    const userId =  document.querySelector("#hidden-user-id-input").dataset.userId;
    const res = await fetch( `/get_random_albums/${userId}`);

    if (!res.ok) {
      alert("Something went wrong :(")
      return;
    }
    const data = await res.json();

    createAlbumUI(data.albums);
  });
});
