module EventsHelper
  CATEGORY_IMAGES = {
    "Musica" => "music_default.jpg",
    "Sport" => "sport_default.jpg",
    "Comedy" => "comedy_default.jpg",
    "Teatro" => "theater_default.jpg",
    "Hobby" => "hobby_default.jpg",
    "Festa" => "party_default.jpg",
    "Arte" => "art_default.jpg",
    "Food&Drinks" => "food_default.jpg"
  }.freeze

  def event_image(event)
    if event.poster_pic.present?
      event.poster_pic
    else
      CATEGORY_IMAGES[event.category] || "default-poster.jpg"
    end
  end
end
