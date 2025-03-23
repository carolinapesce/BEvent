import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["menu"];

    toggle(event) {
        event.stopPropagation(); // Ferma la propagazione del click per evitare che il menu si chiuda immediatamente
        this.menuTarget.classList.toggle("active");
    }

    close(event) {
        // Chiude il menu se il click è avvenuto al di fuori del dropdown
        if (!this.element.contains(event.target)) {
            this.menuTarget.classList.remove("active");
        }
    }

    connect() {
        // Aggiunge un listener per il click su tutto il documento
        document.addEventListener("click", this.close.bind(this));
    }

    disconnect() {
        // Rimuove il listener quando il controller è disconnesso
        document.removeEventListener("click", this.close.bind(this));
    }
}