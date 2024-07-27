document.addEventListener('DOMContentLoaded', () => {
  const loaderButton = document.querySelector('#load-albums-button');
  loaderButton.addEventListener('click', async (e) => {
    e.preventDefault();

    const spinner = document.querySelector("#spinner");
    const userId =  document.querySelector("#hidden-user-id-input").dataset.userId;

    loaderButton.style.display = "none";
    spinner.style.display = "block";
  });
});
