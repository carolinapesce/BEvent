import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  toggleFavorite() {
    // Cambia icona e colore
    this.iconTarget.classList.toggle("fa-regular");
    this.iconTarget.classList.toggle("fa-solid");
    this.iconTarget.classList.toggle("favorited");

    // Aggiunge effetto pop
    this.iconTarget.classList.add("animated");

    // Rimuove l'animazione dopo 200ms per farla ripetere in futuro
    setTimeout(() => {
      this.iconTarget.classList.remove("animated");
    }, 200);
  }
}