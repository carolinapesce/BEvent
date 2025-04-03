import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "progressStep", "progressBar", "nextButton", "prevButton"];

  connect() {
    this.formStepsNum = 0; // Indice dello step corrente
    this.updateFormSteps();
    this.updateProgressbar();
  }

  nextStep(event) {
    if (!this.validateCurrentStep()) {
      event.preventDefault();
      alert("Per favore, compila tutti i campi obbligatori prima di procedere.");
      return;
    }
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

  validateCurrentStep() {
    let currentStepElement = this.stepTargets[this.formStepsNum];
    let inputs = currentStepElement.querySelectorAll("input[required], select[required], textarea[required]");

    let allValid = Array.from(inputs).every(input => {
      if (!input.value.trim()) {
        input.classList.add("error"); // Evidenzia il campo non valido
        return false;
      } else {
        input.classList.remove("error");
        return true;
      }
    });
    return allValid;
  }

  submitForm(event) {
    event.preventDefault(); // Assicura che il comportamento predefinito venga gestito
    this.stepTargets.forEach(step => step.style.display = "block"); // Rendi visibili tutti i campi
    this.element.requestSubmit(); // Invia il form correttamente
  }
}
