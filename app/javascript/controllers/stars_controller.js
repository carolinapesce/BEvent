import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { rating: Number }

  connect() {
    this.element.innerHTML = this.generateStars(this.ratingValue);
  }

  generateStars(rating) {
    let starsHtml = "";
    for (let i = 1; i <= 5; i++) {
      if (i <= rating) {
        starsHtml += '<i class="fa-solid fa-star"></i>'; // Stella piena
      } else {
        starsHtml += '<i class="fa-regular fa-star"></i>'; // Stella vuota
      }
    }
    return starsHtml;
  }
}
