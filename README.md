# Unicorn-Fever-Online
Unicorn Fever 🦄🎲

Unicorn Fever è un gioco multiplayer di scommesse su corse di unicorni, sviluppato in Flutter per il client e Dart per il server. I giocatori possono scommettere su cavalli unicorni, usare carte bonus/malus, e seguire la corsa in tempo reale.

Contenuti

server/ – codice del server in Dart

client/ – app Flutter per dispositivi mobili

assets/images/ – immagini di sfondo e carte

Requisiti

Dart SDK >= 3.0.0

Flutter SDK >= 3.0.0

Dispositivi mobili o emulatori Android/iOS

PC e dispositivo client devono essere sulla stessa rete locale

Installazione

Clona il progetto

git clone <url-del-progetto>
cd unicorn_client


Installa le dipendenze Flutter

flutter pub get


Controlla il file pubspec.yaml
Assicurati che siano presenti:

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  web_socket_channel: ^2.2.0

Avvio Server

Apri il terminale nella cartella del server.

Esegui:

dart run server.dart


Il server si mette in ascolto sulla porta 3000.

Assicurati che il firewall consenta il traffico su quella porta.

Il server assegna automaticamente ID ai giocatori e gestisce le fasi del gioco: attesa giocatori → scommesse → carte → corsa → risultati.

Avvio Client

Apri il terminale nella cartella del client Flutter.

Avvia l’app sul tuo dispositivo o emulator:

flutter run


Premi CONNETTITI sulla schermata iniziale.

Il client si connette al server usando l’IP locale del PC:

String host = '192.168.x.x'; // IP del PC con server
int port = 3000;


PC e dispositivo devono essere collegati allo stesso Wi-Fi.

Struttura del Gioco

Fasi del gioco (GamePhase):

waitingPlayers – in attesa che tutti i giocatori si connettano

betting – fase di scommesse sui cavalli

cards – assegnazione carte bonus/malus ai cavalli

race – corsa dei cavalli passo-passo

results – risultati del round

Gestione carte:

bonus → aumenta la velocità del cavallo

malus → diminuisce la velocità del cavallo

Round e vittoria:

3 round massimi (maxRounds)

Alla fine dell’ultimo round, gameFinished = true e il client mostra la schermata finale.

Note Importanti

Tutti i giocatori devono premere NEXT per passare al round successivo.

Il server invia continuamente lo stato del gioco via WebSocket.

Assicurati che le immagini siano presenti in assets/images/ e dichiarate nel pubspec.yaml.

flutter:
  assets:
    - assets/images/


Se il caricamento sul telefono è infinito, verifica:

IP del server corretto

PC e telefono sulla stessa rete Wi-Fi

Porta 3000 aperta sul firewall
