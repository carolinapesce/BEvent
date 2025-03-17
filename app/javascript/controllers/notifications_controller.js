import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown"];

  toggle() {
    this.dropdownTarget.classList.toggle("active");
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.remove("active");
    }
  }
}