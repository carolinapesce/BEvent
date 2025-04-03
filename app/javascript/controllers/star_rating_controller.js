import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star"]

  connect() {
    this.initializeStars()
    this.setupHover()
  }

  setupHover() {
    this.starTargets.forEach(star => {
      star.addEventListener('mouseenter', (e) => this.handleHover(e))
      star.addEventListener('mouseleave', () => this.resetStars())
    })
  }

  handleHover(event) {
    const hoveredValue = event.currentTarget.getAttribute('for').split('_')[1]
    this.highlightStars(hoveredValue)
  }

  resetStars() {
    const checkedInput = this.element.querySelector('.rating-input:checked')
    if (checkedInput) {
      this.highlightStars(checkedInput.value)
    } else {
      this.starTargets.forEach(star => {
        star.style.color = 'white'
      })
    }
  }

  highlightStars(value) {
    this.starTargets.forEach(star => {
      const starValue = star.getAttribute('for').split('_')[1]
      star.style.color = starValue <= value ? '#FFD700' : 'white'
    })
  }

  rate(event) {
    const ratingValue = event.currentTarget.getAttribute('for').split('_')[1]
    const input = this.element.querySelector(`#star_${ratingValue}`)
    input.checked = true
    this.highlightStars(ratingValue)
  }

  initializeStars() {
    const checkedInput = this.element.querySelector('.rating-input:checked')
    if (checkedInput) {
      this.highlightStars(checkedInput.value)
    }
  }
}