// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"





function toggleSwitch() {
    let switchElement = document.querySelector(".switch-lan");
    switchElement.classList.toggle("active");
}
  
document.addEventListener("DOMContentLoaded", () => {
    const switchElement = document.querySelector(".switch-lan");
    if (switchElement) {
      switchElement.addEventListener("click", toggleSwitch);
    }
});




