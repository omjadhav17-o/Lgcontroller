import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  Future<bool> ConnectToLG() async {
    try {
      final socket = await SSHSocket.connect('192.168.56.101', 22);

      _client = SSHClient(
        socket,
        username: 'lg',
        onPasswordRequest: () => 'lg',
      );
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  Future<SSHSession?> execute1() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }

      final comresult =
          await _client!.execute('echo "search=Satara" > /tmp/query.txt');
      print('execution ok');
      return comresult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
}
