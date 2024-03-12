import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:lgcontollerapp/ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _ipAddressController = TextEditingController();
  final _userNameController = TextEditingController();
  final _password = TextEditingController();
  final _port = TextEditingController();
  final _noOfRigs = TextEditingController();

  @override
  void dispose() {
    _ipAddressController.dispose();
    _userNameController.dispose();
    _password.dispose();
    _port.dispose();
    _noOfRigs.dispose();
    super.dispose();
  }

  Future<void> onloadsave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipAddressController.text = prefs.getString('ipaddress') ?? '';
      _userNameController.text = prefs.getString('userName') ?? '';
      _password.text = prefs.getString('password') ?? '';
      _port.text = prefs.getString('port') ?? '';
      _noOfRigs.text = prefs.getString('rigs') ?? '';
    });
  }

  Future saveInput() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipAddressController.text.isNotEmpty) {
      await prefs.setString('ipaddress', _ipAddressController.text);
    }
    if (_userNameController.text.isNotEmpty) {
      await prefs.setString('userName', _userNameController.text);
    }
    if (_password.text.isNotEmpty) {
      await prefs.setString('password', _password.text);
    }
    if (_port.text.isNotEmpty) {
      await prefs.setString('port', _port.text);
    }
    if (_noOfRigs.text.isNotEmpty) {
      await prefs.setString('rigs', _noOfRigs.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ipAddressController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.computer),
                  labelText: 'IP address',
                  hintText: 'Enter Master IP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'User Name',
                  hintText: 'Enter user name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Enter the Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: _port,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.settings_ethernet),
                  labelText: 'SSH Port',
                  hintText: '22',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: _noOfRigs,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.memory),
                  labelText: 'No. of LG rigs',
                  hintText: 'Enter the number of rigs',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  await saveInput();
                  await onloadsave();

                  SSH ssh = SSH();

                  bool? result = await ssh.ConnectToLG();
                  if (result) {
                    print('success to connect');
                  } else {
                    print('failed to connect');
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cast,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'CONNECT TO LG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  SSH ssh = SSH();
                  await ssh.ConnectToLG();
                  SSHSession? result1 = await ssh.execute1();
                  if (result1 != null) {
                    print('command send successfully');
                  } else {
                    print('failed to send');
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cast,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'SEND COMMAND TO LG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
