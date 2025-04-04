import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["price", "charityFields", "beneficiary", "fundraiserGoal", "charityCheckbox"];

  connect() {
    console.log("Charity Controller Connected");
    this.toggleFields();
  }

  toggleFields() {
    console.log("Checkbox checked?", this.charityCheckboxTarget.checked);
    if (this.charityCheckboxTarget.checked) {
      this.priceTarget.style.display = "none";
      this.charityFieldsTarget.style.display = "block";

      // Svuota il campo prezzo e rimuovi il required
      let priceInput = this.priceTarget.querySelector("input");
      if (priceInput) {
        priceInput.value = "";
        priceInput.removeAttribute("required");
      }

      // Rendi obbligatori i campi di beneficenza
      this.beneficiaryTarget.setAttribute("required", "required");
      this.fundraiserGoalTarget.setAttribute("required", "required");
    } else {
      this.priceTarget.style.display = "block";
      this.charityFieldsTarget.style.display = "none";

      // Svuota i campi di beneficenza e rimuovi required
      this.beneficiaryTarget.value = "";
      this.fundraiserGoalTarget.value = "";
      this.beneficiaryTarget.removeAttribute("required");
      this.fundraiserGoalTarget.removeAttribute("required");

      // Rendi il prezzo obbligatorio
      let priceInput = this.priceTarget.querySelector("input");
      if (priceInput) {
        priceInput.setAttribute("required", "required");
      }
    }
  }
}