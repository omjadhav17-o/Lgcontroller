import 'package:google_maps_flutter/google_maps_flutter.dart';

class BalloonMakers {
  static dashboardBalloon(
    CameraPosition camera,
    String cityName,
    String tabName,
    double height,
  ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>About Data</name>
 <Style id="about_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <h1>$cityName</h1>
        <h2>Om Jadhav</h2>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>${camera.target.longitude}</longitude>
     <latitude>${camera.target.latitude}</latitude>
     <heading>${camera.bearing}</heading>
     <tilt>${camera.tilt}</tilt>
     <range>${11 * 1000}</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${camera.target.longitude},${camera.target.latitude},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

  static blankBalloon() => '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>None</name>
 <Style id="blank">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text><![CDATA[<b>Name:</b> <font color="#ffffff">Om Jadhav</font><br/><b>City:</b> <font color="#ffffff">Pune</font>]]></text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="bb">
   <description></description>
   <styleUrl>#blank</styleUrl>
   <gx:balloonVisibility>0</gx:balloonVisibility>
   <Point>
     <coordinates>0,0,0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';
}
