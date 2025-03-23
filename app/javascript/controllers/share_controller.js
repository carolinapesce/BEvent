import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  copyToClipboard() {
    const url = window.location.href; // Ottieni l'URL corrente
    navigator.clipboard.writeText(url)
      .then(() => {
        this.animateIcon();
        this.showNotification();
      })
      .catch(err => console.error("Errore nella copia:", err));
  }

  animateIcon() {
    this.iconTarget.classList.add("animated");
    setTimeout(() => {
      this.iconTarget.classList.remove("animated");
    }, 200);
  }

  showNotification() {
    // Creiamo la notifica
    const notification = document.createElement("div");
    notification.classList.add("copy-notification");
    notification.textContent = "URL copiato! ✅";

    // Otteniamo la posizione dell'icona
    const rect = this.iconTarget.getBoundingClientRect();
    notification.style.left = `${rect.left + window.scrollX}px`; // Posizione orizzontale
    notification.style.top = `${rect.top + window.scrollY - 40}px`; // Sopra l'icona

    // Aggiungiamo la notifica alla pagina
    document.body.appendChild(notification);

    // Rimuoviamo la notifica dopo 2 secondi
    setTimeout(() => {
      notification.classList.add("fade-out");
      setTimeout(() => notification.remove(), 300);
    }, 800);
  }
}