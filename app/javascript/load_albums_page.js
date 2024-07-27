document.addEventListener('DOMContentLoaded', () => {
  const loaderButton = document.querySelector('#load-albums-button');
  loaderButton.addEventListener('click', async (e) => {
    e.preventDefault();

    const spinner = document.querySelector("#spinner");
    const userId =  document.querySelector("#hidden-user-id-input").dataset.userId;

    loaderButton.style.display = "none";
    spinner.style.display = "block";

    const res = await fetch('/load_albums', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({spotify_user_id: userId})
    });

  });
});
