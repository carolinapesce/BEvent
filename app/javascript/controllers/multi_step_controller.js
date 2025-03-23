import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "progressFill"];

  connect() {
    this.currentStep = 1;
    this.updateProgress();
    this.showStep();
  }

  updateProgress() {
    const totalSteps = this.stepTargets.length;
    const stepPercentage = 100 / (totalSteps - 1);
    
    // La barra deve fermarsi a metà tra un pallino e il successivo
    const progress = (this.currentStep - 1) * stepPercentage + stepPercentage / 2;
    this.progressFillTarget.style.width = `${progress}%`;

    // Attiva i pallini fino alla fase corrente
    document.querySelectorAll(".progress-steps .circle").forEach((circle, index) => {
      if (index + 1 <= this.currentStep) {
        circle.classList.add("active");
      } else {
        circle.classList.remove("active");
      }
    });
  }

  nextStep() {
    if (this.currentStep < this.stepTargets.length) {
      this.currentStep++;
      this.showStep();
    }
  }

  prevStep() {
    if (this.currentStep > 1) {
      this.currentStep--;
      this.showStep();
    }
  }

  showStep() {
    this.stepTargets.forEach((el) => {
      el.classList.toggle("hidden", parseInt(el.dataset.step) !== this.currentStep);
    });

    this.updateProgress();
  }
}