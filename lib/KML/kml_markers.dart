import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> cityCoordinates = [
  const LatLng(18.5204, 73.8567), // Pune
  const LatLng(18.5204, 73.8567), // Pune Central
  const LatLng(18.5610, 73.8100), // Aundh
  const LatLng(18.5365, 73.8930), // Koregaon Park
  const LatLng(18.4474, 73.8649), // Katraj
  const LatLng(18.5037, 73.8071), // Kothrud
  const LatLng(18.5308, 73.8475), // Shivajinagar
  const LatLng(18.5008, 73.8625), // Swargate
  const LatLng(18.5042, 73.9312), // Magarpatta City
  const LatLng(18.5910, 73.7357), // Hinjewadi
  const LatLng(18.6270, 73.7996), // Mumbai
];

CameraPosition lastGMapPosition = const CameraPosition(
  target: LatLng(18.5204, 73.8567),
  zoom: 13.0,
  tilt: 45.0,
  bearing: 30.0,
);

class KMLMakers {
  static String lookAtLinear(double latitude, double longitude, double zoom,
          double tilt, double bearing) =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String lookAt(CameraPosition camera, bool scaleZoom) => '''<LookAt>
  <longitude>${camera.target.longitude}</longitude>
  <latitude>${camera.target.latitude}</latitude>
  
  <range>${scaleZoom ? 130000000.0 : camera.zoom}</range>
  <tilt>${camera.tilt}</tilt>
  <heading>${camera.bearing}</heading>
  <gx:altitudeMode>relativeToGround</gx:altitudeMode>
</LookAt>''';
//scale zoom
  static String orbitLookAtLinear(double latitude, double longitude,
          double zoom, double tilt, double bearing) =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String lookAtLinearInstant(double latitude, double longitude,
          double zoom, double tilt, double bearing) =>
      '<gx:duration>0.5</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String buildTourOfCityAbout() {
    String lookAts = '';

    for (var location in cityCoordinates) {
      lookAts += '''<gx:FlyTo>
  <gx:duration>5.0</gx:duration>
  <gx:flyToMode>bounce</gx:flyToMode>
  ${lookAt(CameraPosition(target: location, zoom: 16, tilt: 30), true)}
</gx:FlyTo>
''';
    }

    lookAts += '''<gx:FlyTo>
  <gx:duration>5.0</gx:duration>
  <gx:flyToMode>bounce</gx:flyToMode>
  ${lookAt(lastGMapPosition, false)}
</gx:FlyTo>
''';

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
   <gx:Tour>
   <name>Orbit</name>
      <gx:Playlist>
         $lookAts
      </gx:Playlist>
   </gx:Tour>
</kml>''';
  }
}
