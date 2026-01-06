🦄 Unicorn Fever Online 🎲

Unicorn Fever è un gioco multiplayer online dove i giocatori scommettono su corse di unicorni!
Sviluppato con Flutter per il client mobile e Dart per il server, il gioco combina strategia, fortuna e interazione in tempo reale.

📂 Struttura del Progetto
Cartella	Descrizione
server/	Codice del server in Dart, gestisce connessioni e logica di gioco
client/	App Flutter per dispositivi mobili Android/iOS
assets/images/	Immagini di sfondo, carte bonus/malus e risorse grafiche
⚙️ Requisiti

Dart SDK >= 3.0.0

Flutter SDK >= 3.0.0

Dispositivo mobile o emulatore Android/iOS

Server e client devono essere sulla stessa rete locale (Wi-Fi)

🚀 Installazione

Clona il repository

git clone <url-del-progetto>
cd unicorn_client


Installa le dipendenze Flutter

flutter pub get


Controlla pubspec.yaml
Assicurati che siano presenti:

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  web_socket_channel: ^2.2.0


Assets
Verifica che le immagini siano presenti in assets/images/ e dichiarate nel pubspec.yaml:

flutter:
  assets:
    - assets/images/

🖥️ Avvio del Server

Apri il terminale nella cartella del server.

Avvia il server:

dart run server.dart


Il server ascolta sulla porta 3000 e assegna automaticamente gli ID ai giocatori.

⚠️ Assicurati che il firewall consenta il traffico sulla porta 3000.

Il server gestisce tutte le fasi del gioco:

attesa giocatori → scommesse → carte → corsa → risultati

📱 Avvio del Client

Apri il terminale nella cartella del client Flutter.

Avvia l’app sul dispositivo o emulator:

flutter run


Premi CONNETTITI nella schermata iniziale.

Il client si collega al server utilizzando l’IP locale del PC:

String host = '192.168.x.x'; // IP del PC che esegue il server
int port = 3000;


⚠️ PC e telefono devono essere connessi allo stesso Wi-Fi.

🎮 Come Funziona il Gioco
Fasi del gioco (GamePhase)
Fase	Descrizione
waitingPlayers	In attesa che tutti i giocatori si connettano
betting	Scommesse sui cavalli unicorni
cards	Assegnazione di carte bonus o malus ai cavalli
race	Corsa dei cavalli, visualizzata passo-passo
results	Risultati del round e aggiornamento soldi
Carte

Bonus → aumenta la velocità del cavallo

Malus → diminuisce la velocità del cavallo

Round e Vittoria

Il gioco prevede un massimo di 3 round (maxRounds)

Alla fine dell’ultimo round, gameFinished = true → viene mostrata la schermata finale

⚠️ Note Importanti

Tutti i giocatori devono premere NEXT per passare al round successivo.

Il server invia continuamente lo stato del gioco via WebSocket.

Se il caricamento sul telefono resta infinito, verifica:

IP del server corretto

PC e dispositivo sulla stessa rete Wi-Fi

Porta 3000 aperta nel firewall
