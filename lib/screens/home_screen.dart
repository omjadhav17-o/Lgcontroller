import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lgcontollerapp/KML/balloon_marker.dart';

import 'package:lgcontollerapp/component/reusable_widget.dart';
import 'package:lgcontollerapp/screens/setting_file.dart';
import 'package:lgcontollerapp/ssh/ssh.dart';

bool connectedstatus = false;
CameraPosition initialMapPosition = const CameraPosition(
  target: LatLng(51.4769, 0.0),
  zoom: 2,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SSH ssh;
  late String lastBalloonProvider;
  Future<void> _connectTolg() async {
    bool resultoconnection = await ssh.ConnectToLG();
    //await ssh.execute1();
    setState(() {
      connectedstatus = resultoconnection;
    });
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Are you sure you want to Reboot?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the action when user confirms
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic here for the action
                await ssh.onReboot();
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  late CameraPosition initialMapPosition;
  late CameraPosition newMapPosition;

  bool orbitPlaying = false;

  orbitPlay() async {
    setState(() {
      orbitPlaying = true;
    });
    ssh.flyTo(newMapPosition.target.latitude, newMapPosition.target.longitude,
        11 * 1000, 0, 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int i = 0; i <= 360; i += 10) {
      if (!mounted) {
        return;
      }
      if (!orbitPlaying) {
        break;
      }
      ssh.flyToOrbit(context, newMapPosition.target.latitude,
          newMapPosition.target.longitude, 13 * 1000, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (!mounted) {
      return;
    }
    ssh.flyTo(newMapPosition.target.latitude, newMapPosition.target.longitude,
        11 * 1000, 0, 0);
    setState(() {
      orbitPlaying = false;
    });
  }

  orbitStop() async {
    setState(() {
      orbitPlaying = false;
    });
    ssh.flyTo(newMapPosition.target.latitude, newMapPosition.target.longitude,
        11 * 1000, 0, 0);
  }

  // done try init state here if we got error
  Future<void> _inatilizeConnection() async {
    if (connectedstatus == true) {
      await ssh.execute1();
    }
  }

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _connectTolg();
    // _inatilizeConnection();

    Future.delayed(Duration.zero).then((x) async {});

    initialMapPosition = const CameraPosition(
      target: LatLng(18.5204, 73.8567), //pune city
      zoom: 2,
    );

    newMapPosition = initialMapPosition;
    ssh.flyTo(
        initialMapPosition.target.latitude,
        initialMapPosition.target.longitude,
        11 * 1000,
        initialMapPosition.tilt,
        initialMapPosition.bearing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Controller App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                ).then((value) {
                  _inatilizeConnection();
                });
                _connectTolg();
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/images/logo.png'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Reusablecard(
                    //todo : add warning button
                    onpress: () {
                      //await ssh.onReLaunch();
                      _showWarningDialog(context);
                    },
                    childCard: const Center(
                      child: Text(
                        'Reboot LG',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Reusablecard(
                    onpress: () async {
                      if (orbitPlaying) {
                        await orbitStop();
                      } else {
                        await orbitPlay();
                      }
                    },
                    childCard: const Center(
                      child: Text(
                        'Orbit Around',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Reusablecard(
                    //todo 3 add snackbar just show that the command executed
                    onpress: () async {
                      lastBalloonProvider = await ssh.renderInSlave(
                          2,
                          BalloonMakers.dashboardBalloon(
                              initialMapPosition, 'pune', 'Om Jadhav', 500));
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(" Command executed"),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    childCard: const Center(
                      child: Text(
                        'Display Information',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Reusablecard(
                    //todo 0:remove execute command from setting screen and add the function to this button
                    onpress: () async {
                      await ssh.execute1();
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(" Located city Pune "),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    childCard: const Center(
                      child: Text(
                        'Locate City Pune',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
