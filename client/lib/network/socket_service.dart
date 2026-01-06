  import 'dart:io';
  import 'dart:convert';
  import '../models/game_state.dart';

  typedef AssignCallback = void Function(int id);
  typedef StateCallback = void Function(GameState game);

  class SocketService {
    late Socket _socket;

    /// Connessione al server
    Future<void> connect({
      required AssignCallback onAssign,
      required StateCallback onState,
      String host = '192.168.1.171',
      int port = 3000,
    }) async {
      try {
        _socket = await Socket.connect(host, port);
        print("✅ Connesso a $host:$port");

        // Ascolta messaggi dal server
        _socket.cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (line) {
            try {
              final Map<String, dynamic> msg = jsonDecode(line);

              if (msg['type'] == 'assign') {
                onAssign(msg['playerId']);
              } else if (msg['type'] == 'state') {
                final game = GameState.fromJson(msg['game']);
                onState(game);
              }
            } catch (e) {
              print("Errore parsing JSON: $e");
            }
          },
          onError: (error) {
            print("Errore socket: $error");
            close();
          },
          onDone: () {
            print("Connessione chiusa dal server");
            close();
          },
        );
      } catch (e) {
        print("Errore connessione: $e");
      }
    }

    /// Invia messaggi al server
    void send(Map<String, dynamic> data) {
      try {
        _socket.write(jsonEncode(data) + '\n');
      } catch (e) {
        print("Errore invio dati: $e");
      }
    }

    /// Chiudi connessione
    void close() {
      try {
        _socket.close();
      } catch (_) {}
    }
  }