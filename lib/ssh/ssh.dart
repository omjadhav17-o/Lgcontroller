import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lgcontollerapp/KML/balloon_marker.dart';
import 'package:lgcontollerapp/KML/kml_markers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  Future<void> getinputPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _host = prefs.getString('ipaddress') ?? '192.168.56.101';
    _port = prefs.getString('port') ?? '22';
    _username = prefs.getString('userName') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('rigs') ?? '3';
  }

  Future<bool> ConnectToLG() async {
    await getinputPref();
    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
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
      await _client!.run(
          "echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_${2}.kml");
      print('balloon created succressfully');
      await _client!.run(
          "echo '${KMLMakers.screenOverlayImage('assets/images/displayimg.jpeg', 2864 / 3000)}' > /var/www/html/kml/slave_${3}.kml");
      final comresult =
          await _client!.execute('echo "search=Pune" > /tmp/query.txt');
      print('execution ok');
      return comresult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<void> createballoon() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      await _client!.run(
          "echo '${BalloonMakers.blankBalloon()}' > /var/www/html/kml/slave_${2}.kml");
      print('balloon created succressfully');
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> onReLaunch() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }

      for (var i = int.parse(_numberOfRigs); i > 0; i--) {
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot"');
        // await ref.read(sshClient)?.run(
        //     'sshpass -p ${ref.read(passwordProvider)} ssh -t lg$i "echo ${ref.read(passwordProvider)} | sudo -S reboot');
      }
      return null;
    } catch (error) {
      print('An error occurred while executing the command: $error');
      return null;
    }
  }

  Future<SSHSession?> CleanKMl() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      await _client!.execute('echo "" > /tmp/query.txt');
      await _client!.execute("echo '' > /var/www/html/kmls.txt");
      print('execution ok2');
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

//create orbit
  Future<File> makeFile(String filename, String content) async {
    var localPath = await getApplicationCacheDirectory();

    File localFile = File('${localPath.path}/filename.kml');
    await localFile.writeAsString(content);
    print('execution ok3');
    return localFile;
  }

  Future<void> kmlFileUpload(File inputFile, String kmlName) async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
      }
      bool uploading = true;
      final sftp = await _client!.sftp();
      final file = await sftp.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file?.write(inputFile.openRead().cast(), onProgress: (progress) {
        var status = progress / fileSize;
        if (fileSize == progress) {
          uploading = false;
        }
      });

      print('execution ok4');
      if (file == null) {
        return;
      }
      // await waitWhile(() => uploading);
      // ref.read(loadingPercentageProvider.notifier).state = null;
    } catch (error) {
      // showSnackBar(
      //     context: context, message: error.toString(), color: Colors.red);
    }
  }

  Future<void> runKml(String kmlName) async {
    try {
      await _client
          ?.run("echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt");
      print('execution ok6');
    } catch (error) {
      // await SSH(ref: ref).connectionRetry(context);
      await runKml(kmlName);
    }
  }

  Future<SSHSession?> orbitAround() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      await _client!.execute('echo "playtour=Orbit" > /tmp/query.txt');
      print('execution ok1');
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> flyTo(double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      Future.delayed(Duration.zero).then((x) async {
        lastGMapPosition = CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: zoom,
          tilt: tilt,
          bearing: bearing,
        );
      });
      await _client?.run(
          'echo "flytoview=${KMLMakers.lookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
      print('fly to command executed  9');
    } catch (error) {
      try {
        // await connectionRetry(context);
        await flyTo(latitude, longitude, zoom, tilt, bearing);
      } catch (e) {}
    }
  }

  flyToOrbit(context, double latitude, double longitude, double zoom,
      double tilt, double bearing) async {
    try {
      await _client!.run(
          'echo "flytoview=${KMLMakers.orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');

      print('flyorbit executed 10');
    } catch (error) {
      //await connectionRetry(context);
      await flyToOrbit(context, latitude, longitude, zoom, tilt, bearing);
    }
  }

  Future<String> renderInSlave(int slaveNo, String kml) async {
    try {
      await _client?.run("echo '$kml' > /var/www/html/kml/slave_$slaveNo.kml");
      print('completed successfully');
      return kml;
    } catch (error) {
      // showSnackBar(
      //     context: context, message: error.toString(), color: Colors.red);
      return BalloonMakers.blankBalloon();
    }
  }
}
