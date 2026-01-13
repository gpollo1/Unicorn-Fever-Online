#Unicorn Fever Online
**Unicorn Fever** è un gioco multiplayer di scommesse su corse di unicorni, sviluppato con **Flutter** (client) e **Dart** (server).  
I giocatori possono scommettere sui cavalli unicorni, usare carte bonus/malus e seguire la corsa in tempo reale.

---

##Caratteristiche principali

- Multiplayer locale o su rete LAN (tramite socket TCP)
- Corse di unicorni con animazioni fluide
- Sistema di scommesse e gestione del denaro dei giocatori
- Carte **bonus** e **malus** per modificare la velocità degli unicorni
- Risultati visualizzati alla fine di ogni round
- Partite a più round con schermata finale e dichiarazione del vincitore

---

##Struttura del progetto

unicorn-fever/
├─ assets/
│ ├─ images/ # Immagini di sfondi, cavalli, carte, monete
├─ lib/
│ ├─ models/ # Modelli: Player, Horse, GameState
│ ├─ network/ # SocketService per connessione server
│ ├─ screens/ # Schermate: Connect, Betting, Cards, Race, Results
│ ├─ main.dart # Entry point del client Flutter
└─ server/
└─ server.dart # Server Dart per gestire la logica di gioco

---

##Requisiti

- Flutter >= 3.0
- Dart >= 3.0
- Dispositivi client e server sulla stessa rete LAN
- Assets (immagini) presenti in `assets/images/`

---

##Installazione
Assicurati di avere Flutter installato sul PC.
- Installa Android Studio o un altro IDE compatibile con Flutter.
- Verifica che l’ambiente Flutter sia configurato correttamente con flutter doctor.
- **Scarica il proggetto:**
- Copia tutte le cartelle e i file del progetto.
- Non dimenticare la cartella assets/images, che contiene tutti gli sfondi, i personaggi e le icone del gioco.
- Apri il progetto in Android Studio
- Seleziona “Open an existing project” e punta alla cartella principale del gioco.
Attenzione necessario avere 2 emulatori per testare il gioco ed è anche necessario andare a cambiare l'indirizzo ip del server mettendo quello del proprio pc dove viene eseguito il server.
##Come giocare
- **Connessione: premi CONNETTITI nella schermata iniziale.
- **Scommesse: seleziona un unicorno e scegli la puntata.
- **Carte: assegna fino a 3 carte bonus/malus agli unicorni.
- **Corsa: osserva gli unicorni correre e attendi i risultati.
- **Risultati: vinci o perdi denaro in base alle scommesse.
- **Round successivi: premi PROSSIMO ROUND fino al termine del gioco.
- **Fine partita: visualizza il vincitore e i soldi finali.

##Architettura
- **Client Flutter: gestione UI, animazioni e invio/ricezione eventi via socket
- **Server Dart: gestione logica di gioco, step-by-step della corsa, carte e scommesse
- **GameState: struttura condivisa client-server, aggiornata in tempo reale
- **SocketService: comunicazione TCP
- **RaceScreen: animazioni dei cavalli e visualizzazione dei risultati
- **CardsScreen: logica per assegnare carte bonus/malus
- **BettingScreen: selezione dell’unicorno e puntata

##Assets richiesti
- c1.jpg … c6.jpg → immagini dei cavalli
- b1.jpg, b2.jpg → carte bonus
- m1.jpg, m2.jpg → carte malus
- sfondo.jpg, sfondo-gara.png → sfondi
- banca.png, coin.png → elementi UI per denaro e puntate

Verifica che tutti gli assets siano presenti nella cartella assets/images e dichiarati in pubspec.yaml.
