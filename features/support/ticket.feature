Feature: Acquisto biglietto

  Scenario: Un utente autenticato acquista un biglietto
    Given esiste un evento pubblico disponibile
    And esiste un utente registrato
    And l’utente ha effettuato l’accesso
    When visita la pagina dell’evento
    And clicca su "Acquista biglietto"
    And inserisce i dati della carta e conferma
    Then il biglietto è creato nel suo account
    And vede il riepilogo della transazione