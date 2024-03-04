import 'package:flutter/material.dart';

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
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.computer),
                  labelText: 'IP address',
                  hintText: 'Enter Master IP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'User Name',
                  hintText: 'Enter user name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Enter the Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                //controller: ,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.settings_ethernet),
                  labelText: 'SSH Port',
                  hintText: '22',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                // controller: _rigsController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.memory),
                  labelText: 'No. of LG rigs',
                  hintText: 'Enter the number of rigs',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
