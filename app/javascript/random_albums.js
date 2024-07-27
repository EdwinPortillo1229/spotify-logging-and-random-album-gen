document.addEventListener('DOMContentLoaded', () => {
  const randomizer = document.querySelector('#get-random-albums-link');

  randomizer.addEventListener('click', (event) => {
    event.preventDefault();
    alert('Fetching random albums...');
  });
});
