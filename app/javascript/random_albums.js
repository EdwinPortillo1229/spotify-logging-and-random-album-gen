document.addEventListener('DOMContentLoaded', () => {
  const randomizer = document.querySelector('#get-random-albums-link');

  randomizer.addEventListener('click', async () => {
    const userId =  document.querySelector("#hidden-user-id-input").dataset.userId;
    const res = await fetch( `/get_random_albums/${userId}`);
    const data = await res.json();
  });
});
