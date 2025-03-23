import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "progressStep", "progressBar", "nextButton", "prevButton"];

  connect() {
    this.formStepsNum = 0; // Indice dello step corrente
    this.updateFormSteps();
    this.updateProgressbar();
  }

  nextStep() {
    if (this.formStepsNum < this.stepTargets.length - 1) {
      this.formStepsNum++;
      this.updateFormSteps();
      this.updateProgressbar();
    }
  }

  prevStep() {
    if (this.formStepsNum > 0) {
      this.formStepsNum--;
      this.updateFormSteps();
      this.updateProgressbar();
    }
  }

  updateFormSteps() {
    this.stepTargets.forEach((formStep, index) => {
      formStep.classList.toggle("form-step-active", index === this.formStepsNum);
    });
  }

  updateProgressbar() {
    this.progressStepTargets.forEach((progressStep, idx) => {
      progressStep.classList.toggle("progress-step-active", idx <= this.formStepsNum);
    });

    const progressActive = this.element.querySelectorAll(".progress-step-active");

    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width =
        ((progressActive.length - 1) / (this.progressStepTargets.length - 1)) * 100 + "%";
    }
  }
}
