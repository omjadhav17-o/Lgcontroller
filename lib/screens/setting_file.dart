import 'package:flutter/material.dart';
import 'package:lgcontollerapp/ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool connectionStatus = false;
  late SSH ssh;

  Future<void> _connectToLG() async {
    bool? result = await ssh.ConnectToLG();
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    onloadsave();
    //connected to lg here again
    _connectToLG();
  }

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

  void showsnackBar(bool setText) async {}

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
                style: ButtonStyle(
                  backgroundColor: connectionStatus
                      ? const MaterialStatePropertyAll(Colors.red)
                      : const MaterialStatePropertyAll(Colors.green),
                  shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (connectionStatus == false) {
                    await saveInput();
                    SSH ssh = SSH();
                    //todo-2 done: working on this result to change the color of the button
                    bool? result = await ssh.ConnectToLG();
                    await ssh.CleanKMl();

                    if (result == true) {
                      print('success to connect');
                      setState(() {
                        connectionStatus = true;
                      });
                      if (!context.mounted) {
                        return;
                      }
                    } else {
                      print('failed to connect');
                    }
                  } else {
                    await ssh.disconnect();
                    setState(() {
                      connectionStatus = false;
                    });
                  }
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: connectionStatus
                        ? const Text("connected to lg rig")
                        : const Text("Failed to connect to lg rig"),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          connectionStatus ? Icons.cloud_off : Icons.cast,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          connectionStatus ? 'Disconnect LG' : 'connect to lg',
                          style: const TextStyle(
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
            ],
          ),
        ));
  }
}
