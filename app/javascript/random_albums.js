document.addEventListener('DOMContentLoaded', () => {
  const createAlbumUI = (data) => {
    const randomAlbumContainer = document.querySelector("#randomized-albums-container");

    let albumDivs = '';

    data.forEach(album => {
      albumDivs += `
        <div class="album-div">
          <div class="image-container">
            <img src="${album.image_url}" class="album-image" style="width:75px;height:75px;">
          </div>
          <div class="album-info-container">
            <p class="album-title">
              ${album.name}
            </p>
            <p class="album-artist">
              ${album.artist}
            </p>
            <p class="album-release_date">
              ${album.release_date}
            </p>
            <p class="album-total_tracks">
              ${album.total_tracks}
            </p>
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
    const data = await res.json();

    createAlbumUI(data.albums);
  });
});
