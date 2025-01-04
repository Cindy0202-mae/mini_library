// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function() {
  // Wait for the page to load, then apply a fade-in effect for each book
  const bookDetails = document.querySelectorAll('.book-details');

  bookDetails.forEach(function(book) {
    book.classList.add('fade-in');
  });
});
