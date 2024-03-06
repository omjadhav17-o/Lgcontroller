import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:lgcontollerapp/ssh/ssh.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
              const TextField(
                //controller: ,
                decoration: InputDecoration(
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
              const TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'User Name',
                  hintText: 'Enter user name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Enter the Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.settings_ethernet),
                  labelText: 'SSH Port',
                  hintText: '22',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const TextField(
                // controller: _rigsController,
                decoration: InputDecoration(
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
