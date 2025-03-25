import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  connect() {
    const isFavorited = this.iconTarget.dataset.status === "true";

    if (isFavorited) {
      this.iconTarget.classList.add("fa-regular");
      this.iconTarget.classList.add("fa-solid");
      this.iconTarget.classList.add("favorited");
    } else {
      this.iconTarget.classList.add("fa-regular");
      this.iconTarget.classList.remove("fa-solid");
      this.iconTarget.classList.remove("favorited");
    }
  }

  toggleFavorite() {
    // Cambia icona e colore
    this.iconTarget.classList.toggle("fa-regular");
    this.iconTarget.classList.toggle("fa-solid");
    this.iconTarget.classList.toggle("favorited");

    // Aggiunge effetto pop
    this.iconTarget.classList.add("animated");

    // Rimuove l'animazione dopo 200ms per farla ripetere in futuro
    setTimeout(() => {
      this.iconTarget.classList.remove("animated");
    }, 200);
  }

  updateFavouriteStatus() {
    if (this.element.dataset.status == "false") {
      const eventId = this.iconTarget.dataset.eventId;
      const userId = this.iconTarget.dataset.userId;
      console.log("eventId", eventId)
      console.log("userId", userId)
      this.addEventToFavourites(eventId, userId)
    } else {
      const favouritesId = this.element.dataset.favouritesId
      this.removeEventFromFavourites(favouritesId)
      /*this.iconTarget.classList.toggle("fa-regular");
      this.iconTarget.classList.toggle("fa-solid");
      this.iconTarget.classList.toggle("favorited");*/
      //this.iconTarget.dataset.status("false");
    }
  }

  addEventToFavourites(eventId, userId) {
    const params = {
      event_id: eventId,
      user_id: userId,
    };
        
    const options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(params),
    };
  
    fetch('/favourites', options)
    .then(response => {
      if (!response.ok) {
        console.log(response.status);
      }
      return response.json();
    })
    .then(data => {
        /*this.element.dataset.wishlistId = data.id;
        this.element.dataset.status = "true";
        this.iconTarget.classList.remove("fill-none");
        this.iconTarget.classList.add("fill-primary");
        
        if (this.textTarget) {
          this.textTarget.innerText = 'Saved';
        }*/

        // Cambia icona e colore
        this.element.dataset.favouritesId = data.id;
        this.element.dataset.status = "true";
        this.iconTarget.classList.add("fa-regular");
        this.iconTarget.classList.add("fa-solid");
        this.iconTarget.classList.add("favorited");
        // Aggiunge effetto pop
        this.iconTarget.classList.toggle("animated");

        // Rimuove l'animazione dopo 200ms per farla ripetere in futuro
        setTimeout(() => {
          this.iconTarget.classList.remove("animated");
        }, 200);

        //this.element.dataset.status("true");

        console.log(data)
      })
    .catch(e => {
      console.log(e);
    });

  }

  removeEventFromFavourites(favouritesId) {
    fetch('/favourites/' + favouritesId, {
      method: 'DELETE',
    })
    .then(response => {
      this.iconTarget.classList.add("fa-regular");
      this.iconTarget.classList.remove("fa-solid");
      this.iconTarget.classList.remove("favorited");
      this.element.dataset.status = "false";
      // Aggiunge effetto pop
      this.iconTarget.classList.add("animated");

      // Rimuove l'animazione dopo 200ms per farla ripetere in futuro
      setTimeout(() => {
        this.iconTarget.classList.remove("animated");
      }, 200);
    })
    .catch(e => {
      console.log(e);
    });
  }

}

  