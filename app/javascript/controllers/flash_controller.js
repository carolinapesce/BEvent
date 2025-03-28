import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = "opacity 0.8s ease-in-out";
      this.element.style.opacity = "0";
      setTimeout(() => this.element.remove(), 500);
    }, 1000); // 3 secondu
  }
}