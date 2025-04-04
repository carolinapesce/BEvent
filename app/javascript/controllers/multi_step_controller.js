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

    this.updateHiddenFields();

    if (this.formStepsNum === this.stepTargets.length - 2) {
      this.showRecap();
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

  
  updateHiddenFields() {
    const fields = [
      ["title", "text"],
      ["category", "select"],
      ["max_participants", "number"],
      ["address", "text"],
      ["city", "text"],
      ["country", "text"],
      ["description", "textarea"],
      ["event_price", "number"],
      ["poster_pic", "file"],
      ["charity_event", "checkbox"],
      ["beneficiary", "text"],
      ["fundraiser_goal", "number"]
    ];

    fields.forEach(([fieldName, type]) => {
      const input = document.querySelector(`[name*='[${fieldName}]']`);
      const hidden = document.getElementById(`hidden_${fieldName}`);

      if (input && hidden) {
        if (type === "checkbox") {
          hidden.value = input.checked ? "Sì" : "No";
        } else if (type === "file") {
          hidden.value = input.files.length > 0 ? input.files[0].name : "";
        } else {
          hidden.value = input.value;
        }
      }
    });

    // ✅ NUOVO: composizione manuale del datetime di inizio
    const startHidden = document.getElementById("hidden_start_datetime");
    if (startHidden) {
      startHidden.value = this.composeDatetime("start");
    }

    // ✅ NUOVO: composizione manuale del datetime di fine
    const endHidden = document.getElementById("hidden_end_datetime");
    if (endHidden) {
      endHidden.value = this.composeDatetime("end");
    }
  
  }

  composeDatetime(prefix) {
    const y = document.querySelector(`#event_${prefix}_datetime_1i`)?.value;
    const m = document.querySelector(`#event_${prefix}_datetime_2i`)?.value.padStart(2, '0');
    const d = document.querySelector(`#event_${prefix}_datetime_3i`)?.value.padStart(2, '0');
    const h = document.querySelector(`#event_${prefix}_datetime_4i`)?.value.padStart(2, '0');
    const min = document.querySelector(`#event_${prefix}_datetime_5i`)?.value.padStart(2, '0');

    if (y && m && d && h && min) {
      return `${d}/${m}/${y} ${h}:${min}`;
    }
    return "-";
  }

  showRecap() {
    const map = {
      title: "preview_title",
      category: "preview_category",
      start_datetime: "preview_start_datetime",
      end_datetime: "preview_end_datetime",
      max_participants: "preview_max_participants",
      address: "preview_address",
      city: "preview_city",
      country: "preview_country",
      description: "preview_description",
      poster_filename: "preview_poster",
      event_price: "preview_price",
      charity_event: "preview_charity",
      beneficiary: "preview_beneficiary",
      fundraiser_goal: "preview_goal"
    };

    Object.entries(map).forEach(([hiddenId, previewId]) => {
      const hidden = document.getElementById(`hidden_${hiddenId}`);
      const preview = document.getElementById(previewId);

      if (hidden && preview) {
        preview.textContent = hidden.value || "-";
      }
    });
  }

  submitForm(event) {
    this.element.submit(); // Invia il form correttamente
  }
}
