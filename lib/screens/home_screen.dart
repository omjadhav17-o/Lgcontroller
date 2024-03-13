import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lgcontollerapp/KML/balloon_marker.dart';
import 'package:lgcontollerapp/KML/kml_markers.dart';
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
    setState(() {
      connectedstatus = resultoconnection;
    });
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
  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _connectTolg();

    Future.delayed(Duration.zero).then((x) async {
      //ref.read(playingGlobalTourProvider.notifier).state = false;
    });
    // if (widge) {
    //   initialMapPosition = const CameraPosition(
    //     target: LatLng(0, 0),
    //     zoom: 0,
    //   );
    // } else {}
    initialMapPosition = const CameraPosition(
      target: LatLng(18.5204, 73.8567),
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
                );
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
              children: [
                Expanded(
                  child: Reusablecard(
                    //todo : add warning button
                    onpress: () async {
                      await ssh.onReLaunch();
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
                      //  if (!isConnectedToLg) {
                      //                 showSnackBar(
                      //                     context: context,
                      //                     message: translate(
                      //                         'settings.connection_required'));
                      //                 return;
                      //               }
                      if (orbitPlaying) {
                        await orbitStop();
                      } else {
                        await orbitPlay();
                      }
                      //todo 2:add snackbar with button to stop orbit and keep snack bar for 10 secs
                      const SnackBar(
                        content: Column(
                          children: [Text('stop orbit')],
                        ),
                      );
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
                      await ssh.orbitAround();
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
