// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"

document.addEventListener("turbo:load", function() {
  const themeToggle = document.getElementById("theme-toggle");
  const htmlTag = document.documentElement;

  const savedMode = localStorage.getItem("theme-toggle");

  // Set theme mode based on local storage or default to 'light'
  if (savedMode === "dark") {
    htmlTag.classList.add("dark");
    themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
  } else {
    themeToggle.innerHTML = '<i class="fa-solid fa-moon"></i>';
  }

  themeToggle.addEventListener("click", function() {
    const mode = htmlTag.classList.toggle("dark");
    localStorage.setItem("theme-toggle", mode ? "dark" : "light");

    if (htmlTag.classList.contains('dark')) {
      themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
    } else {
      themeToggle.innerHTML = '<i class="fa-solid fa-moon"></i>'; // Change button icon to moon
    }
  });
});
