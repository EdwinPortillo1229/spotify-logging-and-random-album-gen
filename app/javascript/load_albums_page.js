document.addEventListener('DOMContentLoaded', () => {
  const loaderButton = document.querySelector('#load-albums-button');
  loaderButton.addEventListener('click', async (e) => {
    e.preventDefault();
    loaderButton.style.display = "none";
    const spinner = document.querySelector("#spinner");
    spinner.style.display = "block";
  });
});
